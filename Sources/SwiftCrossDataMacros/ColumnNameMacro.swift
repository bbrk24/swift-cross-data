import SwiftSyntaxMacros
import SwiftSyntax
import MacroToolkit

public enum ColumnNameMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let attr = Attribute(node).asMacroAttribute else {
            preconditionFailure("ColumnName is not macro?")
        }

        guard attr.arguments.count == 1,
            attr.arguments[0].label == nil || attr.arguments[0].label == "_"
        else {
            throw DiagnosticError(description: "ColumnName takes a single unlabelled argument")
        }

        guard let stringLiteral = StringLiteral(attr.arguments[0].expr),
            !stringLiteral.containsInterpolation
        else {
            throw DiagnosticError(description: "ColumnName argument must be a string literal")
        }

        return []
    }
}
