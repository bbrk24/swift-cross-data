# Using the Database

All database methods are asynchronous. They're serialized internally so that the database is safe to
use from multiple threads, though keep in mind that making database calls concurrent will not
actually improve performance.

All database methods are also marked `throws`. Database calls can throw for a variety of reasons,
such as I/O to the .sqlite file failing.

## SELECT

The method `Database.select` represents SQL `SELECT` statements. These can be used to retrieve
values from the database or count how many rows exist matching a certain predicate.

The `select` method itself does not perform any querying. Rather, it returns a query wrapper with
two methods:

- `count()` performs a query like `SELECT COUNT(*)`, and returns the number of rows that exist
  matching the criteria given.
- `collect()` performs a query like `SELECT *`, and returns the contents of the rows that match. You
  may optionally pass a range-replaceable container type in which to store the elements, e.g.
  `collect(as: ContiguousArray.self)`, which defaults to `Array` if not specified.

## INSERT

The method `Database.insert` represents SQL `INSERT` statements. It takes a sequence of items that
do not have their IDs set, and returns an array containing equivalents with their IDs set. Because
the IDs are required for `delete` and `update` calls to function, you should not use models after
passing them to `insert`, and instead use the return value. If you do not need the models after
creating them, you may say `_ = try await db.insert(...)`.

There is also an overload to create a single model instance:

```swift
@inlinable
public func insert<M: Model>(_ value: consuming M) async throws -> M {
    return try await insert(CollectionOfOne(value))[0]
}
```

## UPDATE

TODO

## DELETE

TODO
