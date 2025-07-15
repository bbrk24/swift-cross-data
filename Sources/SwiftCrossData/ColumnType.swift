// TODO: NSDate, NSDecimalNumber and UUID
#if CORE_DATA
    import CoreData

    public protocol ColumnType: Sendable {
        static var attributeType: NSAttributeType { get }
        static var isOptional: Bool { get }
        var asNSObject: NSObject { get }
    }

    extension Int16: ColumnType {
        public static var attributeType: NSAttributeType {
            .integer16AttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }
    }

    extension Int32: ColumnType {
        public static var attributeType: NSAttributeType {
            .integer32AttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }
    }

    extension Int64: ColumnType {
        public static var attributeType: NSAttributeType {
            .integer64AttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }
    }

    extension Double: ColumnType {
        public static var attributeType: NSAttributeType {
            .doubleAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }
    }

    extension Float: ColumnType {
        public static var attributeType: NSAttributeType {
            .floatAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }
    }

    extension Bool: ColumnType {
        public static var attributeType: NSAttributeType {
            .booleanAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }
    }

    extension URL: ColumnType {
        public static var attributeType: NSAttributeType {
            .URIAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { self as NSURL }
    }

    extension String: ColumnType {
        public static var attributeType: NSAttributeType {
            .stringAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { self as NSString }
    }

    extension Data: ColumnType {
        public static var attributeType: NSAttributeType {
            .binaryDataAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { self as NSData }
    }

    extension Optional: ColumnType where Wrapped: ColumnType {
        public static var attributeType: NSAttributeType {
            Wrapped.attributeType
        }

        public static var isOptional: Bool { true }

        public var asNSObject: NSObject {
            self?.asNSObject ?? NSNull()
        }
    }
#else
    import Foundation

    public enum SqliteTypeName: Sendable, Hashable {
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
                return "BLOB"
            case .null(let inner):
                return inner.castTypeString
            }
        }
    }

    public enum SqliteValue: Sendable, Hashable {
        case integer(Int64)
        case real(Double)
        case text(String)
        case blob(Data)
        case null
    }

    public protocol ColumnType: Sendable {
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
