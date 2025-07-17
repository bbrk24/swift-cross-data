import Foundation

#if CORE_DATA
    infix operator <- : AssignmentPrecedence
#else
    import SQLite
#endif

enum SqlExpression: Sendable {
    case column(name: String)
    indirect case unaryOperator(
        operation: String,
        expression: SqlExpression,
        isPrefix: Bool = true,
        isExpression: Bool = true
    )
    indirect case binaryOperator(
        operation: String,
        lhs: SqlExpression,
        rhs: SqlExpression,
        isExpression: Bool = true,
        childrenAreExpressions: Bool = true
    )
    case functionCall(functionName: String, arguments: [SqlExpression])
    indirect case cast(
        expression: SqlExpression,
        sourceType: any ColumnType.Type,
        destinationType: any ColumnType.Type
    )
    case literal(value: any ColumnType)
}

public struct ExpressionProxy<T: ColumnType> {
    var expression: SqlExpression

    init(expression: SqlExpression) {
        self.expression = expression
    }
    public init(_ value: T) {
        expression = .literal(value: value)
    }

    public static prefix func + (operand: ExpressionProxy<T>) -> ExpressionProxy<T> {
        return operand
    }

    #if CORE_DATA
        public static func == (
            lhs: ExpressionProxy<T>,
            rhs: ExpressionProxy<T>
        ) -> ExpressionProxy<Bool> {
            .init(
                expression: .binaryOperator(
                    operation: "=",
                    lhs: lhs.expression,
                    rhs: rhs.expression,
                    isExpression: false,
                    childrenAreExpressions: true
                )
            )
        }
        public static func != (
            lhs: ExpressionProxy<T>,
            rhs: ExpressionProxy<T>
        ) -> ExpressionProxy<Bool> {
            .init(
                expression: .binaryOperator(
                    operation: "!=",
                    lhs: lhs.expression,
                    rhs: rhs.expression,
                    isExpression: false,
                    childrenAreExpressions: true
                )
            )
        }
    #else
        public static func == <Wrapped: ColumnType>(
            lhs: ExpressionProxy<Wrapped?>,
            rhs: _OptionalNilComparisonType
        ) -> ExpressionProxy<Bool>
        where T == Wrapped? {
            .init(
                expression: .unaryOperator(
                    operation: " ISNULL",
                    expression: lhs.expression,
                    isPrefix: false
                )
            )
        }
        public static func != <Wrapped: ColumnType>(
            lhs: ExpressionProxy<Wrapped?>,
            rhs: _OptionalNilComparisonType
        ) -> ExpressionProxy<Bool>
        where T == Wrapped? {
            .init(
                expression: .unaryOperator(
                    operation: " NOT NULL",
                    expression: lhs.expression,
                    isPrefix: false
                )
            )
        }

        public static func == (
            lhs: ExpressionProxy<T>,
            rhs: ExpressionProxy<T>
        ) -> ExpressionProxy<Bool> {
            .init(
                expression: .binaryOperator(
                    operation: "IS NOT DISTINCT FROM",
                    lhs: lhs.expression,
                    rhs: rhs.expression
                )
            )
        }
        public static func != (
            lhs: ExpressionProxy<T>,
            rhs: ExpressionProxy<T>
        ) -> ExpressionProxy<Bool> {
            .init(
                expression: .binaryOperator(
                    operation: "IS DISTINCT FROM",
                    lhs: lhs.expression,
                    rhs: rhs.expression
                )
            )
        }
    #endif

    public static func == (lhs: ExpressionProxy<T>, rhs: T) -> ExpressionProxy<Bool> {
        lhs == ExpressionProxy(rhs)
    }
    public static func != (lhs: ExpressionProxy<T>, rhs: T) -> ExpressionProxy<Bool> {
        lhs != ExpressionProxy(rhs)
    }
    public static func == (lhs: T, rhs: ExpressionProxy<T>) -> ExpressionProxy<Bool> {
        ExpressionProxy(lhs) == rhs
    }
    public static func != (lhs: T, rhs: ExpressionProxy<T>) -> ExpressionProxy<Bool> {
        ExpressionProxy(lhs) != rhs
    }

    public func cast<U>(to _: U.Type = U.self) -> ExpressionProxy<U> {
        .init(
            expression: .cast(
                expression: self.expression,
                sourceType: T.self,
                destinationType: U.self
            )
        )
    }

    public static func <- (lhs: inout ExpressionProxy<T>, rhs: T) {
        lhs = ExpressionProxy(rhs)
    }

    public static func <- (lhs: inout ExpressionProxy<T>, rhs: ExpressionProxy<T>) {
        lhs = rhs
    }
}

extension ExpressionProxy where T == String {
    public func lowercased() -> ExpressionProxy<String> {
        #if CORE_DATA
            let functionName = "lowercase"
        #else
            let functionName = "LOWER"
        #endif

        return .init(
            expression: .functionCall(functionName: functionName, arguments: [self.expression])
        )
    }

    public func uppercased() -> ExpressionProxy<String> {
        #if CORE_DATA
            let functionName = "uppercase"
        #else
            let functionName = "UPPER"
        #endif

        return .init(
            expression: .functionCall(functionName: functionName, arguments: [self.expression])
        )
    }

    public func matchesGlob(_ template: ExpressionProxy<String>) -> ExpressionProxy<Bool> {
        #if CORE_DATA
            let globOperator = "LIKE"
        #else
            let globOperator = "GLOB"
        #endif

        return .init(
            expression: .binaryOperator(
                operation: globOperator,
                lhs: self.expression,
                rhs: template.expression,
                isExpression: false,
                childrenAreExpressions: true
            )
        )
    }
    public func matchesGlob(_ template: String) -> ExpressionProxy<Bool> {
        matchesGlob(ExpressionProxy(template))
    }

    public var count: ExpressionProxy<Int32> {
        .init(expression: .functionCall(functionName: "length", arguments: [self.expression]))
    }
}

extension String {
    public func matchesGlob(_ template: ExpressionProxy<String>) -> ExpressionProxy<Bool> {
        ExpressionProxy(self).matchesGlob(template)
    }
}

extension ExpressionProxy {
    public func cast() -> ExpressionProxy<Double> where T == Float {
        .init(expression: self.expression)
    }
    public func cast() -> ExpressionProxy<Float> where T == Double {
        .init(expression: self.expression)
    }
}

extension ExpressionProxy where T == Bool {
    public static prefix func ! (operand: ExpressionProxy<Bool>) -> ExpressionProxy<Bool> {
        .init(
            expression: .unaryOperator(
                operation: "NOT ",
                expression: operand.expression,
                isExpression: false
            )
        )
    }

    public static func && (
        lhs: ExpressionProxy<Bool>,
        rhs: ExpressionProxy<Bool>
    ) -> ExpressionProxy<Bool> {
        .init(
            expression: .binaryOperator(
                operation: "AND",
                lhs: lhs.expression,
                rhs: rhs.expression,
                isExpression: false,
                childrenAreExpressions: false
            )
        )
    }
    public static func && (lhs: ExpressionProxy<Bool>, rhs: Bool) -> ExpressionProxy<Bool> {
        if rhs {
            lhs
        } else {
            ExpressionProxy(false)
        }
    }
    public static func && (lhs: Bool, rhs: ExpressionProxy<Bool>) -> ExpressionProxy<Bool> {
        if lhs {
            rhs
        } else {
            ExpressionProxy(false)
        }
    }

    public static func || (
        lhs: ExpressionProxy<Bool>,
        rhs: ExpressionProxy<Bool>
    ) -> ExpressionProxy<Bool> {
        .init(
            expression: .binaryOperator(
                operation: "OR",
                lhs: lhs.expression,
                rhs: rhs.expression,
                isExpression: false,
                childrenAreExpressions: false
            )
        )
    }
    public static func || (lhs: ExpressionProxy<Bool>, rhs: Bool) -> ExpressionProxy<Bool> {
        if rhs {
            ExpressionProxy(true)
        } else {
            lhs
        }
    }
    public static func || (lhs: Bool, rhs: ExpressionProxy<Bool>) -> ExpressionProxy<Bool> {
        if lhs {
            ExpressionProxy(true)
        } else {
            rhs
        }
    }
}

@dynamicMemberLookup
public struct TableProxy<M: Model> {
    public subscript<C: ColumnType>(dynamicMember keyPath: WritableKeyPath<M, C>)
        -> ExpressionProxy<C>
    {
        get {
            guard let columnName = M.getColumnName(forKeyPath: keyPath) else {
                preconditionFailure("Could not find column name for key path \(keyPath)")
            }

            return .init(expression: .column(name: columnName))
        }
    }
}

@dynamicMemberLookup
public struct MutableTableProxy<M: Model> {
    var columnMap: [String: SqlExpression] = [:]

    public subscript<C: ColumnType>(dynamicMember keyPath: WritableKeyPath<M, C>)
        -> ExpressionProxy<C>
    {
        get {
            guard let columnName = M.getColumnName(forKeyPath: keyPath) else {
                preconditionFailure("Could not find column name for key path \(keyPath)")
            }

            let expression = columnMap[columnName] ?? .column(name: columnName)

            return .init(expression: expression)
        }
        set {
            guard let columnName = M.getColumnName(forKeyPath: keyPath) else {
                preconditionFailure("Could not find column name for key path \(keyPath)")
            }

            columnMap[columnName] = newValue.expression
        }
    }

    @available(
        *,
        unavailable,
        message:
            "Columns from the table are not accessible as their actual values in the 'where:' and 'set:' callbacks. If you are trying to assign a constant to a column, use the operator '<-' instead of '='."
    )
    public subscript<C: ColumnType>(dynamicMember keyPath: WritableKeyPath<M, C>) -> C {
        get {
            fatalError()
        }
        set {
            guard let columnName = M.getColumnName(forKeyPath: keyPath) else {
                preconditionFailure("Could not find column name for key path \(keyPath)")
            }

            columnMap[columnName] = .literal(value: newValue)
        }
    }
}
