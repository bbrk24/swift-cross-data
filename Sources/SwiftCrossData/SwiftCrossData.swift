@attached(member, names: named(rowid))
@attached(peer, names: prefixed(SCDataModel_))
@attached(extension, conformances: Model, names: named(properties), named(init))
public macro Model() = #externalMacro(module: "SwiftCrossDataMacros", type: "ModelMacro")
