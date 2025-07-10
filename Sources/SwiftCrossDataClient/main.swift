import SwiftCrossData

@Model
struct Foo {
    var name: String
}

let db = try! Database(models: [Foo.self], dbFileName: "./db.sqlite")

print(try! await db.insert(Foo(name: "new model")))

print(try! await db.delete(from: Foo.self, where: { foo in foo.name == "new model" }))

print(try! await db.select(from: Foo.self, where: { _ in ExpressionProxy(true) }).collect())
