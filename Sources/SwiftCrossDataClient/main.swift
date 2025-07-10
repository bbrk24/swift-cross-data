import SwiftCrossData

@Model
struct Foo {
    var name: String
}

let db = try! Database(models: [Foo.self], dbFileName: "./db.sqlite")

print(try! await db.insert(Foo(name: "new model")))

let models =
    try! await db.select(
        from: Foo.self,
        limit: 2,
        offset: 1,
        where: { _ in
            ExpressionProxy(true)
        }
    )
    .collect()

print(models)
