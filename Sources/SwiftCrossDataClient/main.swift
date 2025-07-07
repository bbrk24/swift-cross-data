import SwiftCrossData

@Model
struct Foo {
    var name: String
}

let db = Database(models: [Foo.self], dbFileName: "./db.sqlite")

let models = await db.select(from: Foo.self, where: { foo in
    foo.name.matchesGlob("*bar*")
}).collect()

print(models)
