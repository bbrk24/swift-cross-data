@attached(member, names: named(rowid), named(managedObject))
@attached(peer, names: prefixed(SCDataModel_))
@attached(
    extension,
    conformances: Model,
    names: named(properties),
    named(init),
    named(ManagedObjectType),
    named(debugDescription)
)
public macro Model() = #externalMacro(module: "SwiftCrossDataMacros", type: "ModelMacro")
