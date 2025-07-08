import SwiftCrossData

@Model
struct Foo {
    var name: String
}

let db = try! Database(models: [Foo.self], dbFileName: "./db.sqlite")

print(try! await db.select(from: Foo.self) { _ in ExpressionProxy(true) }.count())

let models = try! await db.select(from: Foo.self, where: { foo in
    foo.name.count > 5
}).collect()

print(models)
