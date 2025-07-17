import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
public struct SwiftCrossDataPlugin: CompilerPlugin {
    public let providingMacros: [Macro.Type] = [
        ModelMacro.self,
        ColumnNameMacro.self,
    ]

    public init() {}
}
