#if canImport(CoreData)
    @_exported import CoreData
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
#endif

public struct Database: Sendable {
    #if canImport(CoreData)
    #else
        let connectionWrapper: ConnectionWrapper
    #endif

    public init(
        models: [any Model.Type],
        dbFileName: String
    ) throws {
        #if canImport(CoreData)
            fatalError("TODO")
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
        #if canImport(CoreData)
            fatalError("TODO")
        #else
            try await connectionWrapper.withConnection { conn in
                func createSetter<T: ColumnType>(
                    value: S.Element,
                    keyPath: PartialKeyPath<S.Element>,
                    columnType: T.Type,
                    columnName: String
                ) -> Setter {
                    let keyPath = keyPath as! WritableKeyPath<S.Element, T>
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

                let table = Table(S.Element.getTableName())

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
        #if canImport(CoreData)
            fatalError("TODO")
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
        #if canImport(CoreData)
            fatalError("TODO")
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
        #if canImport(CoreData)
            fatalError("TODO")
        #else
            let expression = predicate(.init()).expression

            let (whereClause, arguments) = QueryWrapper<M>.compile(expression: expression)
            let quotedTableName = SQLite.Expression<Int>(M.getTableName()).description

            let queryString = "DELETE FROM \(quotedTableName) WHERE \(whereClause);"

            return try await connectionWrapper.withConnection {
                [queryString, arguments] (conn) in

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

    #if canImport(CoreData)
        public func count() async throws -> Int64 {
            fatalError("TODO")
        }

        public func collect<C: RangeReplaceableCollection<T> & Sendable>(
            as _: C.Type
        ) async throws -> C {
            fatalError("TODO")
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
