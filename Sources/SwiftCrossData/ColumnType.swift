// TODO: NSDate, NSDecimalNumber and UUID
#if CORE_DATA
    import CoreData

    public protocol ColumnType: Sendable {
        /// The attribute type used to initialize the NSEntityDescription.
        static var attributeType: NSAttributeType { get }
        /// Whether the type may include `nil` values.
        static var isOptional: Bool { get }
        /// Convert `self` to an argument for a formatted `NSPredicate`.
        var asNSObject: NSObject { get }

        /// The type used to represent this value in `@NSManaged` properties.
        associatedtype ScalarType = Self
        /// The type used to represent this value in optional `@NSManaged` properties.
        ///
        /// For numeric types, this is `NSNumber`, since `@NSManaged` properties cannot be optional
        /// primitives.
        associatedtype NonScalarType = ScalarType
        /// Convert a value from ``ScalarType``.
        static func fromScalar(_ scalar: ScalarType) -> Self
        /// Convert a value from ``NonScalarType``.
        static func fromNonScalar(_ nonScalar: NonScalarType) -> Self
        /// Convert `self` to a scalar value for use with `NSManagedObject.setValue(_:forKey:)`.
        func toScalar() -> ScalarType
        /// Convert `self` to `NonScalarType`.
        func toNonScalar() -> NonScalarType
    }

    extension ColumnType where ScalarType == Self {
        public static func fromScalar(_ scalar: ScalarType) -> Self {
            scalar
        }

        public func toScalar() -> ScalarType {
            self
        }
    }

    extension ColumnType where NonScalarType == Self {
        public static func fromNonScalar(_ nonScalar: NonScalarType) -> Self {
            nonScalar
        }

        public func toNonScalar() -> NonScalarType {
            self
        }
    }

    extension Int16: ColumnType {
        public static var attributeType: NSAttributeType {
            .integer16AttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }

        public typealias NonScalarType = NSNumber

        public static func fromNonScalar(_ nonScalar: NSNumber) -> Int16 {
            nonScalar.int16Value
        }

        public func toNonScalar() -> NonScalarType {
            .init(value: self)
        }
    }

    extension Int32: ColumnType {
        public static var attributeType: NSAttributeType {
            .integer32AttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }

        public typealias NonScalarType = NSNumber

        public static func fromNonScalar(_ nonScalar: NSNumber) -> Int32 {
            nonScalar.int32Value
        }

        public func toNonScalar() -> NonScalarType {
            .init(value: self)
        }
    }

    extension Int64: ColumnType {
        public static var attributeType: NSAttributeType {
            .integer64AttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }

        public typealias NonScalarType = NSNumber

        public static func fromNonScalar(_ nonScalar: NSNumber) -> Int64 {
            nonScalar.int64Value
        }

        public func toNonScalar() -> NonScalarType {
            .init(value: self)
        }
    }

    extension Double: ColumnType {
        public static var attributeType: NSAttributeType {
            .doubleAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }

        public typealias NonScalarType = NSNumber

        public static func fromNonScalar(_ nonScalar: NSNumber) -> Double {
            nonScalar.doubleValue
        }

        public func toNonScalar() -> NonScalarType {
            .init(value: self)
        }
    }

    extension Float: ColumnType {
        public static var attributeType: NSAttributeType {
            .floatAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }

        public typealias NonScalarType = NSNumber

        public static func fromNonScalar(_ nonScalar: NSNumber) -> Float {
            nonScalar.floatValue
        }

        public func toNonScalar() -> NonScalarType {
            .init(value: self)
        }
    }

    extension Bool: ColumnType {
        public static var attributeType: NSAttributeType {
            .booleanAttributeType
        }

        public static var isOptional: Bool { false }

        public var asNSObject: NSObject { NSNumber(value: self) }

        public typealias NonScalarType = NSNumber

        public static func fromNonScalar(_ nonScalar: NSNumber) -> Bool {
            nonScalar.boolValue
        }

        public func toNonScalar() -> NonScalarType {
            .init(value: self)
        }
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

        public typealias ScalarType = Wrapped.NonScalarType?
        public typealias NonScalarType = Never

        public static func fromScalar(_ scalar: Wrapped.NonScalarType?) -> Wrapped? {
            scalar.map(Wrapped.fromNonScalar(_:))
        }

        public static func fromNonScalar(_ nonScalar: Never) -> Wrapped? {
        }

        public func toScalar() -> Wrapped.NonScalarType? {
            self.map { $0.toNonScalar() }
        }

        public func toNonScalar() -> Never {
            preconditionFailure("Don't nest optionals")
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
