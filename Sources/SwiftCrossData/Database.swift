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

        func withConnection<T, E: Error>(
            _ body: @Sendable (borrowing Connection) throws(E) -> T
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

public final class Database: Sendable {
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
        where predicate: (TableProxy<T>) -> ExpressionProxy<Bool>
    ) -> QueryWrapper<T> {
        return .init(
            db: self,
            sortFields: sortFields,
            expression: predicate(.init()).expression
        )
    }

    public func insert<T: Model>(_ values: T...) async throws {
        return try await insert(values)
    }

    public func insert<C: Collection>(_ values: sending C) async throws
    where C.Element: Model {
        #if canImport(CoreData)
            fatalError("TODO")
        #else
            try await connectionWrapper.withConnection { [values] (conn) in
                for value in values {
                    func createSetter<T: ColumnType>(
                        keyPath: PartialKeyPath<C.Element>,
                        columnType: T.Type,
                        columnName: String
                    ) -> Setter {
                        let keyPath = keyPath as! WritableKeyPath<C.Element, T>
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

                    let statement = Table(C.Element.getTableName())
                        .insert(
                            or: .abort,
                            C.Element.properties.map {
                                createSetter(
                                    keyPath: $0.keyPath,
                                    columnType: $0.columnType,
                                    columnName: $0.columnName
                                )
                            }
                        )

                    try conn.run(statement)
                }
            }
        #endif
    }
}

public enum SortDirection {
    case asc, desc
}

public struct SortItem<T: Model> {
    var keyPath: PartialKeyPath<T>
    var direction: SortDirection

    public init<U>(_ keyPath: WritableKeyPath<T, U>, direction: SortDirection = .asc) {
        self.keyPath = keyPath
        self.direction = direction
    }
}

public struct QueryWrapper<T: Model> {
    let db: Database
    let sortFields: [SortItem<T>]
    let expression: SqlExpression

    #if canImport(CoreData)
        public func count() async throws -> Int64 {
            fatalError("TODO")
        }

        public func collect<C: RangeReplaceableCollection>(as _: C.Type) async throws -> C
        where C.Element == T {
            fatalError("TODO")
        }
    #else
        private static func compile(expression: SqlExpression) -> (String, [Binding?]) {
            switch expression {
            case .column(let name):
                // generic argument doesn't matter
                return (SQLite.Expression<Int>(name).description, [])
            case .unaryOperator(let operation, let expression, let isPrefix):
                let (inner, args) = compile(expression: expression)
                if isPrefix {
                    return (operation + inner, args)
                } else {
                    return (inner + operation, args)
                }
            case .binaryOperator(let operation, let lhs, let rhs):
                let (lhsInner, lhsArgs) = compile(expression: lhs)
                let (rhsInner, rhsArgs) = compile(expression: rhs)

                return ("\(lhsInner) \(operation) \(rhsInner)", lhsArgs + rhsArgs)
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
            let (whereClause, arguments) = Self.compile(expression: self.expression)

            let quotedTableName = SQLite.Expression<Int>(T.getTableName()).description

            let queryString = "SELECT COUNT(*) FROM \(quotedTableName) WHERE \(whereClause);"

            return try await db.connectionWrapper.withConnection { [queryString] (conn) in
                let query = try conn.prepare(queryString, arguments)

                _ = try query.step()
                return query.row[0]
            }
        }

        public func collect<C: RangeReplaceableCollection>(as _: C.Type) async throws -> C
        where C.Element == T {
            let (whereClause, arguments) = Self.compile(expression: self.expression)

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
            queryString += "rowid;"

            return try await db.connectionWrapper.withConnection { [queryString] (conn) in
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
