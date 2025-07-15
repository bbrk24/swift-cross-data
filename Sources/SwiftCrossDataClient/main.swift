import SwiftCrossData

@Model
struct Foo {
    var name: String
}

let db = try! Database(models: [Foo.self], dbFileName: "./db.sqlite")

let count = try! await db.select(from: Foo.self, where: { _ in ExpressionProxy(true) }).count()
if count < 5 {
    _ = try! await db.insert([
        Foo(name: "Alice"),
        Foo(name: "Bob"),
        Foo(name: "Charlie"),
        Foo(name: "David"),
        Foo(name: "Eve"),
    ])
}

print(
    try! await db.update(
        Foo.self,
        set: { foo in
            foo.name = foo.name.uppercased()
        },
        where: { foo in
            foo.name.count < 5
        }
    )
)

print(try! await db.select(from: Foo.self, where: { _ in ExpressionProxy(true) }).collect())
