#if CORE_DATA
    @_exported import CoreData

    extension NSManagedObjectContext {
        func performAsync<T: Sendable, E: Error>(
            _ body: sending @escaping () throws(E) -> T
        ) async throws(E) -> T {
            do {
                return try await withCheckedThrowingContinuation { continuation in
                    self.perform {
                        continuation.resume(with: Result { try body() })
                    }
                }
            } catch {
                throw error as! E
            }
        }
    }
#else
    import SQLite
    import Foundation

    actor ConnectionWrapper {
        private let connection: Connection

        init(connection: sending Connection) {
            self.connection = connection
        }

        func withConnection<T: Sendable, E: Error>(
            _ body: sending (borrowing Connection) throws(E) -> T
        ) throws(E) -> T {
            return try body(connection)
        }
    }

    func createColumn(type: SqliteTypeName, name: String, builder t: TableBuilder) {
        switch type {
        case .integer:
            t.column(SQLite.Expression<Int64>(name))
        case .real:
            t.column(SQLite.Expression<Double>(name))
        case .text:
            t.column(SQLite.Expression<String>(name))
        case .blob:
            t.column(SQLite.Expression<Data>(name))
        case .null(let inner):
            switch inner {
            case .integer:
                t.column(SQLite.Expression<Int64?>(name))
            case .real:
                t.column(SQLite.Expression<Double?>(name))
            case .text:
                t.column(SQLite.Expression<String?>(name))
            case .blob:
                t.column(SQLite.Expression<Data?>(name))
            case .null(_):
                createColumn(type: inner, name: name, builder: t)
            }
        }
    }

    func createSetter<M: Model, T: ColumnType>(
        value: M,
        keyPath: PartialKeyPath<M>,
        columnType: T.Type,
        columnName: String
    ) -> Setter {
        let keyPath = keyPath as! WritableKeyPath<M, T>
        let sqliteValue = value[keyPath: keyPath].sqliteValue

        return switch sqliteValue {
        case .integer(let i):
            SQLite.Expression(columnName) <- i
        case .real(let r):
            SQLite.Expression(columnName) <- r
        case .text(let s):
            SQLite.Expression(columnName) <- s
        case .blob(let b):
            SQLite.Expression(columnName) <- b
        case .null:
            SQLite.Expression<Int?>(columnName) <- nil
        }
    }
#endif

public struct Database: @unchecked Sendable {
    #if CORE_DATA
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    #else
        let connectionWrapper: ConnectionWrapper
    #endif

    public init(
        models: [any Model.Type],
        dbFileName: String
    ) throws {
        #if CORE_DATA
            let model = NSManagedObjectModel()

            model.entities = models.map {
                let entity = NSEntityDescription()
                entity.name = $0.getTableName()
                entity.properties = []

                func openExistential(_ model: (some Model).Type) {
                    entity.managedObjectClassName = NSStringFromClass(model.ManagedObjectType.self)

                    for property in model.properties {
                        let attributeDescription = NSAttributeDescription()
                        attributeDescription.name = property.columnName
                        attributeDescription.attributeType = property.columnType.attributeType
                        attributeDescription.isOptional = property.columnType.isOptional
                        attributeDescription.defaultValue = property.defaultValue

                        entity.properties.append(attributeDescription)
                    }
                }

                openExistential($0)

                return entity
            }

            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

            let storeUrl = URL(fileURLWithPath: dbFileName)

            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: storeUrl
            )

            context.persistentStoreCoordinator = coordinator
        #else
            let connection = try Connection(.uri(dbFileName))

            for model in models {
                let table = Table(model.getTableName())
                try connection.run(
                    table.create(ifNotExists: true) { t in
                        t.column(SQLite.Expression<Int64>("rowid"), primaryKey: true)

                        func propertyIterate(_ model: (some Model).Type) {
                            for property in model.properties {
                                createColumn(
                                    type: property.columnType.sqliteTypeName,
                                    name: property.columnName,
                                    builder: t
                                )
                            }
                        }

                        propertyIterate(model)
                    }
                )
            }

            self.connectionWrapper = .init(connection: consume connection)
        #endif
    }

    public func select<T: Model>(
        from _: T.Type = T.self,
        orderBy sortFields: [SortItem<T>] = [],
        limit: Int? = nil,
        offset: Int? = nil,
        where predicate: (borrowing TableProxy<T>) -> ExpressionProxy<Bool>
    ) -> QueryWrapper<T> {
        return .init(
            db: self,
            sortFields: sortFields,
            expression: predicate(.init()).expression,
            limit: limit,
            offset: offset
        )
    }

    public func insert<M: Model>(_ value: consuming M) async throws -> M {
        return try await insert([value])[0]
    }

    public func insert<S: Sequence>(_ values: sending S) async throws -> [S.Element]
    where S.Element: Model {
        #if CORE_DATA
            try await context.performAsync {
                do {
                    let results = try values.map { (value: consuming S.Element) in
                        var value = consume value

                        guard
                            let entity = NSEntityDescription.entity(
                                forEntityName: S.Element.getTableName(),
                                in: context
                            )
                        else {
                            throw SaveFailedError(
                                debugDescription: "NSEntityDescription.entity returned nil"
                            )
                        }
                        let model = S.Element.ManagedObjectType.init(
                            entity: entity,
                            insertInto: context
                        )

                        for property in S.Element.properties {
                            model.setValue(
                                value[keyPath: property.keyPath],
                                forKey: property.columnName
                            )
                        }

                        value.managedObject = model
                        return value
                    }

                    if results.isEmpty {
                        return []
                    }

                    try context.save()
                    return results
                } catch {
                    context.rollback()
                    throw error
                }
            }
        #else
            let table = Table(S.Element.getTableName())

            return try await connectionWrapper.withConnection { conn in
                var results: [S.Element] = []

                try conn.transaction {
                    results = try values.map { (value: consuming S.Element) in
                        let statement = table.insert(
                            or: .abort,
                            S.Element.properties.map {
                                createSetter(
                                    value: value,
                                    keyPath: $0.keyPath,
                                    columnType: $0.columnType,
                                    columnName: $0.columnName
                                )
                            }
                        )

                        let rowid = try conn.run(statement)

                        value.rowid = rowid
                        return value
                    }
                }

                return results
            }
        #endif
    }

    public func delete<M: Model>(_ model: consuming M) async throws {
        #if CORE_DATA
            try await delete([model])
        #else
            try await connectionWrapper.withConnection { conn in
                _ = try conn.run(
                    Table(M.getTableName())
                        .filter(SQLite.Expression<Int64>("rowid") == model.rowid)
                        .delete()
                )
            }
        #endif
    }

    @discardableResult
    public func delete<S: Sequence>(_ models: sending S) async throws -> Int
    where S.Element: Model {
        #if CORE_DATA
            try await context.performAsync {
                var count = 0
                for model in models {
                    guard let managedObject = model.managedObject else {
                        continue
                    }
                    count += 1

                    context.delete(managedObject)
                }

                if count > 0 {
                    try context.save()
                }
                return count
            }
        #else
            try await connectionWrapper.withConnection { conn in
                try conn.run(
                    Table(S.Element.getTableName())
                        .filter(models.map(\.rowid).contains(SQLite.Expression("rowid")))
                        .delete()
                )
            }
        #endif
    }

    @discardableResult
    public func delete<M: Model>(
        from _: M.Type,
        where predicate: (borrowing TableProxy<M>) -> ExpressionProxy<Bool>
    ) async throws -> Int {
        let expression = predicate(.init()).expression

        #if CORE_DATA
            let (format, arguments) = QueryWrapper<M>.compile(expression: expression)

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: M.getTableName())
            request.predicate = NSPredicate(format: format, argumentArray: arguments)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            deleteRequest.resultType = .resultTypeCount

            return try await context.performAsync {
                let result = try context.execute(deleteRequest) as! NSBatchDeleteResult

                if context.hasChanges {
                    try context.save()
                }

                return result.result as! Int
            }
        #else
            let (whereClause, arguments) = QueryWrapper<M>.compile(expression: expression)
            let quotedTableName = SQLite.Expression<Int>(M.getTableName()).description

            let queryString = "DELETE FROM \(quotedTableName) WHERE \(whereClause);"

            return try await connectionWrapper.withConnection { conn in
                try conn.run(queryString, arguments)
                return conn.changes
            }
        #endif
    }

    @discardableResult
    public func update<T: Model>(
        _: T.Type,
        set updater: (inout MutableTableProxy<T>) -> Void,
        where predicate: (borrowing TableProxy<T>) -> ExpressionProxy<Bool>
    ) async throws -> Int {
        let expression = predicate(.init()).expression

        var mutationProxy = MutableTableProxy<T>()
        updater(&mutationProxy)

        #if CORE_DATA
            let (format, arguments) = QueryWrapper<T>.compile(expression: expression)

            let request = NSBatchUpdateRequest(entityName: T.getTableName())
            request.predicate = NSPredicate(format: format, argumentArray: arguments)

            request.resultType = .updatedObjectsCountResultType
            request.propertiesToUpdate = [:]

            for (columnName, expression) in mutationProxy.columnMap {
                if case .column(name: columnName) = expression {
                    continue
                }

                let (exprString, setterArgs) = QueryWrapper<T>
                    .compile(expression: expression, forExpression: true)

                request.propertiesToUpdate![columnName] = NSExpression(
                    format: exprString,
                    argumentArray: setterArgs
                )
            }

            return try await context.performAsync {
                let result = try context.execute(request) as! NSBatchUpdateResult

                if context.hasChanges {
                    try context.save()
                }

                return result.result as! Int
            }
        #else
            var arguments: [Binding?] = []
            var setters: [String] = []

            for (columnName, expression) in mutationProxy.columnMap {
                if case .column(name: columnName) = expression {
                    continue
                }

                let (exprString, setterArgs) = QueryWrapper<T>.compile(expression: expression)
                let quotedColumnName = SQLite.Expression<Int>(columnName).description

                arguments += setterArgs
                setters.append("\(quotedColumnName) = \(exprString)")
            }

            if setters.isEmpty {
                return 0
            }

            let (whereClause, whereArguments) = QueryWrapper<T>.compile(expression: expression)
            arguments += whereArguments

            let quotedTableName = SQLite.Expression<Int>(T.getTableName()).description

            let queryString =
                "UPDATE \(quotedTableName) SET \(setters.joined(separator: ", ")) WHERE \(whereClause);"

            return try await connectionWrapper.withConnection {
                [arguments] (conn) in

                try conn.run(queryString, arguments)
                return conn.changes
            }
        #endif
    }
}

public enum SortDirection: Sendable, Hashable, BitwiseCopyable {
    case asc, desc
}

/// Fetching the row failed due to a SQLite error.
public struct ReadFailedError: Error {
}

/// Saving the row failed due to an internal problem.
public struct SaveFailedError: Error, CustomDebugStringConvertible {
    public var debugDescription: String
}

public struct SortItem<T: Model>: Sendable {
    var keyPath: PartialKeyPath<T> & Sendable
    var direction: SortDirection

    public init<U: ColumnType>(
        _ keyPath: WritableKeyPath<T, U> & Sendable,
        _ direction: SortDirection = .asc
    ) {
        self.keyPath = keyPath
        self.direction = direction
    }
}

public struct QueryWrapper<T: Model>: Sendable {
    let db: Database
    let sortFields: [SortItem<T>]
    let expression: SqlExpression
    let limit: Int?
    let offset: Int?

    #if CORE_DATA
        static func compile(
            expression: SqlExpression,
            forExpression: Bool = false
        ) -> (String, [NSObject]) {
            switch expression {
            case .column(let name):
                return ("%K", [name as NSString])
            case .unaryOperator(let operation, let expression, let isPrefix):
                let (inner, args) = compile(expression: expression)

                if isPrefix {
                    return ("(\(operation)\(inner))", args)
                } else {
                    return ("(\(inner)\(operation))", args)
                }
            case .binaryOperator(let operation, let lhs, let rhs):
                let (lhsInner, lhsArgs) = compile(expression: lhs)
                let (rhsInner, rhsArgs) = compile(expression: rhs)

                return ("(\(lhsInner) \(operation) \(rhsInner))", lhsArgs + rhsArgs)
            case .functionCall(let functionName, let arguments):
                var output = functionName + "("
                var varargs: [NSObject] = []

                var isFirst = true
                for argument in arguments {
                    if isFirst {
                        isFirst = false
                    } else {
                        output += ", "
                    }

                    let (innerPred, innerArgs) = compile(expression: argument, forExpression: true)
                    output += innerPred
                    varargs += innerArgs
                }
                output += ")"

                return (output, varargs)
            case .cast(let expression, let sourceType, let destinationType):
                if sourceType.attributeType == destinationType.attributeType {
                    return compile(expression: expression, forExpression: forExpression)
                }
                fatalError("CoreData CAST is unimplemented")
            case .literal(let value):
                if let value = value as? Bool {
                    if value {
                        return (forExpression ? "TRUE" : "TRUEPREDICATE", [])
                    } else {
                        return (forExpression ? "FALSE" : "FALSEPREDICATE", [])
                    }
                }

                return ("%@", [value.asNSObject])
            }
        }

        public func count() async throws -> Int64 {
            let (format, arguments) = Self.compile(expression: self.expression)

            let request = NSFetchRequest<T.ManagedObjectType>(entityName: T.getTableName())
            request.predicate = NSPredicate(format: format, argumentArray: arguments)
            request.fetchOffset = offset ?? 0
            request.resultType = .countResultType

            if let limit {
                request.fetchLimit = limit
            }

            return try await db.context.performAsync {
                let result = try db.context.count(for: request)
                return Int64(result)
            }
        }

        public func collect<C: RangeReplaceableCollection<T> & Sendable>(
            as _: C.Type
        ) async throws -> C {
            let (format, arguments) = Self.compile(expression: self.expression)

            let request = NSFetchRequest<T.ManagedObjectType>(entityName: T.getTableName())
            request.predicate = NSPredicate(format: format, argumentArray: arguments)
            request.sortDescriptors = sortFields.map {
                NSSortDescriptor(
                    key: T.getColumnName(forKeyPath: $0.keyPath),
                    ascending: $0.direction == .asc
                )
            }
            request.fetchOffset = offset ?? 0
            request.returnsObjectsAsFaults = false

            if let limit {
                request.fetchLimit = limit
            }

            return try await db.context.performAsync {
                let array = try db.context.fetch(request)

                // `array` can't be sent, and is of the wrong type anyway
                var result = C()
                result.reserveCapacity(array.count)
                for value in array {
                    result.append(T.init(managedObject: value))
                }
                return result
            }
        }
    #else
        static func compile(expression: SqlExpression) -> (String, [Binding?]) {
            switch expression {
            case .column(let name):
                // generic argument doesn't matter
                return (SQLite.Expression<Int>(name).description, [])
            case .unaryOperator(let operation, let expression, let isPrefix):
                let (inner, args) = compile(expression: expression)

                if isPrefix {
                    return ("(\(operation)\(inner))", args)
                } else {
                    return ("(\(inner)\(operation))", args)
                }
            case .binaryOperator(let operation, let lhs, let rhs):
                let (lhsInner, lhsArgs) = compile(expression: lhs)
                let (rhsInner, rhsArgs) = compile(expression: rhs)

                return ("(\(lhsInner) \(operation) \(rhsInner))", lhsArgs + rhsArgs)
            case .functionCall(let functionName, let arguments):
                var output = functionName + "("
                var sqlArgs: [Binding?] = []

                var isFirst = true
                for argument in arguments {
                    if isFirst {
                        isFirst = false
                    } else {
                        output += ", "
                    }

                    let (innerSql, innerArgs) = compile(expression: argument)
                    output += innerSql
                    sqlArgs += innerArgs
                }
                output += ")"

                return (output, sqlArgs)
            case .cast(let expression, let sourceType, let destinationType):
                if sourceType.sqliteTypeName == destinationType.sqliteTypeName {
                    return compile(expression: expression)
                } else {
                    let (inner, args) = compile(expression: expression)
                    return (
                        "CAST(\(inner) AS \(destinationType.sqliteTypeName.castTypeString))", args
                    )
                }
            case .literal(let value):
                switch value.sqliteValue {
                case .integer(let i):
                    return ("?", [i])
                case .real(let r):
                    return ("?", [r])
                case .text(let s):
                    return ("?", [s])
                case .blob(let b):
                    return ("?", [b.datatypeValue])
                case .null:
                    return ("NULL", [])
                }
            }
        }

        public func count() async throws -> Int64 {
            var (whereClause, arguments) = Self.compile(expression: self.expression)

            let quotedTableName = SQLite.Expression<Int>(T.getTableName()).description

            var queryString = "SELECT COUNT(*) FROM \(quotedTableName) WHERE \(whereClause)"

            if let limit {
                queryString += " LIMIT ?"
                arguments.append(Int64(limit))
            }
            if let offset {
                queryString += " OFFSET ?"
                arguments.append(Int64(offset))
            }

            queryString += ";"

            return try await db.connectionWrapper.withConnection {
                [queryString, arguments] (conn) in

                let query = try conn.prepare(queryString, arguments)

                guard try query.step() else {
                    throw ReadFailedError()
                }
                return query.row[0]
            }
        }

        public func collect<C: RangeReplaceableCollection<T> & Sendable>(
            as _: C.Type
        ) async throws -> C {
            var (whereClause, arguments) = Self.compile(expression: self.expression)

            // generic argument doesn't matter
            let quotedTableName = SQLite.Expression<Int>(T.getTableName()).description

            var queryString = "SELECT * FROM \(quotedTableName) WHERE \(whereClause) ORDER BY "

            for field in sortFields {
                guard let columnName = T.getColumnName(forKeyPath: field.keyPath) else {
                    preconditionFailure("Could not find column name for key path \(field.keyPath)")
                }

                let directionString =
                    switch field.direction {
                    case .asc:
                        "ASC"
                    case .desc:
                        "DESC"
                    }

                queryString +=
                    "\(SQLite.Expression<Int>(columnName).description) \(directionString), "
            }
            queryString += "rowid"

            if let limit {
                queryString += " LIMIT ?"
                arguments.append(Int64(limit))
            }
            if let offset {
                queryString += " OFFSET ?"
                arguments.append(Int64(offset))
            }

            queryString += ";"

            return try await db.connectionWrapper.withConnection {
                [queryString, arguments] (conn) in

                let rows = try conn.prepareRowIterator(queryString, bindings: arguments)

                var results = C.init()

                for row in IteratorSequence(rows) {
                    results.append(try T.init(row: row))
                }

                return results
            }
        }
    #endif

    public func collect() async throws -> [T] {
        try await collect(as: Array.self)
    }
}
