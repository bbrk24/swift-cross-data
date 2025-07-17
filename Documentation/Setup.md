# Setup

## Defining a Table

A table is represented by a Model struct. Model structs are simple structs annotated with the
`@Model` macro, for example:

```swift
import SwiftCrossData

@Model
struct User {
    var name: String
    var passwordHash: String
    var email: String
    var age: Int16
}
```

The macro does a few things:
- It creates a property to hold the row's identity: rowid in SQLite, or the `NSManagedObject`
  instance in CoreData.
- It creates an initializer that takes the SQLite row or `NSManagedObject` instance and hydrates all
  the properties.
- If you don't provide a `debugDescription`, one will be generated for you. The generated
  `debugDescription` looks like the default one for structs, but it skips the generated identity
  property.
- With CoreData only, it creates a subclass of `NSManagedObject` to represent the model.

Default supported column types are:
- `Int16`, `Int32`, and `Int64`
- `Float` and `Double`
- `Bool`
- `String`
- `Foundation.URL`
- `Foundation.Data`
- Optionals of the above (nested optionals are not supported)

### Column Names

By default, the column names are the same as the property names. This can be customized with the
`@ColumnName` attribute:

```swift
import SwiftCrossData

@Model
struct User {
    @ColumnName("user_name")
    var name: String

    @ColumnName("password")
    var passwordHash: String

    var email: String
    var age: Int16
}
```

Due to technical restrictions with CoreData, column names cannot be the same as the name of any
property or zero-argument method on `NSManagedObject` (including its superclass, `NSObject`), and
must be valid C identifiers.

### Table Name

The table name defaults to the struct's name in snake_case. To customize the table name, override
the static method `getTableName`:

```swift
import SwiftCrossData

@Model
struct User {
    var name: String
    var passwordHash: String
    var email: String
    var age: Int16

    static func getTableName() -> String { "users" }
}
```

## Creating a Database

You can connect to a database by instantiating `Database`:

```swift
import SwiftCrossData

let db = try Database(models: [User.self], dbFileName: "/path/to/db.sqlite")
```

`models` is a list of model struct types representing the tables in the database.

`dbFileName` is the path to the file where the data is stored. If the file does not exist, it is
created with the specified set of tables. Every table starts empty. Other files may be created in
the same directory, with names based on this file name -- in this example, you might also see
`/path/to/db.sqlite-wal`.

It is not recommended to have multiple `Database` instances pointing at the same file.
