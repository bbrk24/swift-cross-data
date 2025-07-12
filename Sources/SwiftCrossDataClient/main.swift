import SwiftCrossData

@Model
struct Foo {
    var name: String
}

let db = try! Database(models: [Foo.self], dbFileName: "./db.sqlite")

print(try! await db.update(
    Foo.self,
    set: { foo in
        foo.name = foo.name.uppercased()
    },
    where: { foo in
        foo.name.count < 5
    }
))

print(try! await db.select(from: Foo.self, where: { _ in ExpressionProxy(true) }).collect())
