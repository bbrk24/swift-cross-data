import SwiftCrossData

@Model
struct Foo {
    var name: String
}

let db = try! Database(models: [Foo.self], dbFileName: "./db.sqlite")

let models = try! await db.select(from: Foo.self, where: { foo in
    foo.name == "child"
}).collect()

print(models)
