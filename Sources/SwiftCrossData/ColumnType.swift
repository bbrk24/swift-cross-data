// TODO: NSDate, NSDecimalNumber and UUID
#if canImport(CoreData)
    import CoreData

    public protocol ColumnType {
        static var attributeType: NSAttributeDescription.AttributeType { get }
        static var isOptional: Bool { get }
    }

    extension Int16: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .integer16
        }

        public static var isOptional: Bool { false }
    }

    extension Int32: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .integer32
        }

        public static var isOptional: Bool { false }
    }

    extension Int64: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .integer64
        }

        public static var isOptional: Bool { false }
    }

    extension Double: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .double
        }

        public static var isOptional: Bool { false }
    }

    extension Float: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .float
        }

        public static var isOptional: Bool { false }
    }

    extension Bool: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .boolean
        }

        public static var isOptional: Bool { false }
    }

    extension URL: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .uri
        }

        public static var isOptional: Bool { false }
    }

    extension String: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .string
        }

        public static var isOptional: Bool { false }
    }

    extension Data: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            .binaryData
        }

        public static var isOptional: Bool { false }
    }

    extension Optional: ColumnType where Wrapped: ColumnType {
        public static var attributeType: NSAttributeDescription.AttributeType {
            Wrapped.attributeType
        }

        public static var isOptional: Bool { true }
    }
#else
    import Foundation

    public enum SqliteTypeName: Sendable, Equatable {
        case integer, real, text, blob
        indirect case null(SqliteTypeName)

        public static func notNull(_ type: SqliteTypeName) -> SqliteTypeName {
            if case .null(let inner) = type {
                return .notNull(inner)
            } else {
                return type
            }
        }

        var castTypeString: String {
            switch self {
            case .integer:
                return "INTEGER"
            case .real:
                return "REAL"
            case .text:
                return "TEXT"
            case .blob:
                return "NONE"
            case .null(let inner):
                return inner.castTypeString
            }
        }
    }

    public enum SqliteValue: Sendable {
        case integer(Int64)
        case real(Double)
        case text(String)
        case blob(Data)
        case null
    }

    public protocol ColumnType {
        static var sqliteTypeName: SqliteTypeName { get }
        var sqliteValue: SqliteValue { get }
        static func decode(sqliteValue: SqliteValue) -> Self?
    }

    extension Int16: ColumnType {
        public static var sqliteTypeName: SqliteTypeName { .integer }

        public var sqliteValue: SqliteValue {
            .integer(Int64(self))
        }

        public static func decode(sqliteValue: SqliteValue) -> Int16? {
            if case .integer(let value) = sqliteValue {
                return Int16(exactly: value)
            } else {
                return nil
            }
        }
    }

    extension Int32: ColumnType {
        public static var sqliteTypeName: SqliteTypeName { .integer }

        public var sqliteValue: SqliteValue {
            .integer(Int64(self))
        }

        public static func decode(sqliteValue: SqliteValue) -> Int32? {
            if case .integer(let value) = sqliteValue {
                return Int32(exactly: value)
            } else {
                return nil
            }
        }
    }

    extension Int64: ColumnType {
        public static var sqliteTypeName: SqliteTypeName { .integer }

        public var sqliteValue: SqliteValue {
            .integer(self)
        }

        public static func decode(sqliteValue: SqliteValue) -> Int64? {
            if case .integer(let value) = sqliteValue {
                return value
            } else {
                return nil
            }
        }
    }

    extension Double: ColumnType {
        public static var sqliteTypeName: SqliteTypeName {
            .real
        }

        public var sqliteValue: SqliteValue {
            .real(self)
        }

        public static func decode(sqliteValue: SqliteValue) -> Double? {
            if case .real(let value) = sqliteValue {
                return value
            } else {
                return nil
            }
        }
    }

    extension Float: ColumnType {
        public static var sqliteTypeName: SqliteTypeName {
            .real
        }

        public var sqliteValue: SqliteValue {
            .real(Double(self))
        }

        public static func decode(sqliteValue: SqliteValue) -> Float? {
            if case .real(let value) = sqliteValue {
                return Float(value)
            } else {
                return nil
            }
        }
    }

    extension Bool: ColumnType {
        public static var sqliteTypeName: SqliteTypeName {
            .integer
        }

        public var sqliteValue: SqliteValue {
            .integer(self ? 1 : 0)
        }

        public static func decode(sqliteValue: SqliteValue) -> Bool? {
            switch sqliteValue {
            case .integer(0):
                return false
            case .integer(1):
                return true
            default:
                return nil
            }
        }
    }

    extension URL: ColumnType {
        public static var sqliteTypeName: SqliteTypeName {
            .text
        }

        public var sqliteValue: SqliteValue {
            .text(absoluteString)
        }

        public static func decode(sqliteValue: SqliteValue) -> URL? {
            if case .text(let value) = sqliteValue {
                return URL(string: value)
            } else {
                return nil
            }
        }
    }

    extension String: ColumnType {
        public static var sqliteTypeName: SqliteTypeName {
            .text
        }

        public var sqliteValue: SqliteValue {
            .text(self)
        }

        public static func decode(sqliteValue: SqliteValue) -> String? {
            if case .text(let value) = sqliteValue {
                return value
            } else {
                return nil
            }
        }
    }

    extension Data: ColumnType {
        public static var sqliteTypeName: SqliteTypeName {
            .blob
        }

        public var sqliteValue: SqliteValue {
            .blob(self)
        }

        public static func decode(sqliteValue: SqliteValue) -> Data? {
            if case .blob(let value) = sqliteValue {
                return value
            } else {
                return nil
            }
        }
    }

    extension Optional: ColumnType where Wrapped: ColumnType {
        public static var sqliteTypeName: SqliteTypeName {
            .null(Wrapped.sqliteTypeName)
        }

        public var sqliteValue: SqliteValue {
            switch self {
            case .none:
                .null
            case .some(let value):
                value.sqliteValue
            }
        }

        public static func decode(sqliteValue: SqliteValue) -> Wrapped?? {
            if case .null = sqliteValue {
                return .some(.none)
            } else if let wrapped = Wrapped.decode(sqliteValue: sqliteValue) {
                return .some(.some(wrapped))
            } else {
                return .none
            }
        }
    }
#endif
