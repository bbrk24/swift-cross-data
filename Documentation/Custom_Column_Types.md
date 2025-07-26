# Custom Column Types

Using custom types for columns is not recommended. However, it is possible to do so. Besides being
`Sendable`, the requirements differ between CoreData and SQLite.

## In SQLite

When using SQLite, `ColumnType` has three requirements:

```swift
public protocol ColumnType: Sendable {
    static var sqliteTypeName: SqliteTypeName { get }
    var sqliteValue: SqliteValue { get }
    static func decode(sqliteValue: SqliteValue) -> Self?
}
```

- `sqliteTypeName` is the type name used in the `CREATE TABLE` statement. Unlike in SQL, types
  default to non-optional and you have to explicitly opt-in to allowing nulls. Valid values are:
  - Plain types: `.integer`, `.real`, `.text`, `.blob`
  - Optional types: `.null(inner)` where `inner` is any of the above
  - Explicitly non-optional types: `.notNull(inner)` is the same as `inner` if it's a plain type,
    but unwraps `.null`s so that `.notNull(.null(x)) == x`.
- `sqliteValue` is the value used for encoding, mainly used for `INSERT` and `UPDATE` statements,
  but also for literals in the `WHERE` clause of a `SELECT` statement. This must match
  `sqliteTypeName` (for example, don't list the type name as `.integer` and try to encode a value
  as `.text(...)`).
- `decode(sqliteValue:)` is the reverse of the previous operation. It's given as a static method
  rather than an initializer so that it can be implemented by Objective-C classes like
  `NSDate` and `NSDecimalNumber` (for which support is planned but not currently available).

## In CoreData

`ColumnType` has more requirements with CoreData:

```swift
public protocol ColumnType: Sendable {
    static var attributeType: NSAttributeType { get }
    static var isOptional: Bool { get }
    static var nsObjectType: NSObject.Type { get }
    var asNSObject: NSObject { get }
    associatedtype ScalarType = Self
    associatedtype NonScalarType = ScalarType
    static func fromScalar(_ scalar: ScalarType) -> Self
    static func fromNonScalar(_ nonScalar: NonScalarType) -> Self
    func toScalar() -> ScalarType
    func toNonScalar() -> NonScalarType
}
```

- `attributeType` and `isOptional` are used to set up the `NSAttributeDescription` for the column.
- `asNSObject` is used to convert the value to something that can be put in the argument array when
  initializing an `NSPredicate`. This is used for `UPDATE` statements and the `WHERE` clause of
  `SELECT` statements. If your type is nullable, use `NSNull` to represent null values.
- `nsObjectType` is the type used for `CAST` expressions. It should generally be the same type that
  `asNSObject` returns, but this is not enforced.
- `ScalarType` and `NonScalarType` are the types used to represent the column in `NSManagedObject`
  subclasses when the column is non-nullable and nullable, respectively. These have to be different
  for some types:

  - For numbers, `NonScalarType = NSNumber`, because types like `Int?` can't be represented in
    Objective-C.
  - For `Optional`, `ScalarType = Optional<Wrapped.NonScalarType>` for obvious reasons.

  `toScalar`, `toNonScalar`, `fromScalar`, and `fromNonScalar` are the conversion functions used.
  They have default implementations when the relevant type is `Self`.
