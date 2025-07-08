import SwiftSyntaxMacros
import SwiftSyntax
import SwiftDiagnostics
import MacroToolkit

public enum ModelMacro: MemberMacro, PeerMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let declaration = declaration.as(StructDeclSyntax.self) else {
            throw DiagnosticError(description: "Models must be structs")
        }

        let str = Struct(declaration)

        let properties = str.properties.filter(\.isStored)
        
        var propertyElements = ""
        var initStatements = ""

        for property in properties {
            let columnName = property.identifier

            initStatements += "self.\(property.identifier) = try decodeRowValue(row, \"\(columnName)\")\n"

            if let initialValue = property.initialValue {
                propertyElements += #"""
                    .init(
                        keyPath: \\#(str.identifier).\#(property.identifier),
                        columnName: "\#(columnName)",
                        defaultValue: \#(initialValue._syntax.description)
                    ),
                    """#
            } else {
                propertyElements += #"""
                    .init(
                        keyPath: \\#(str.identifier).\#(property.identifier),
                        columnName: "\#(columnName)"
                    ),
                    """#
            }
        }
        
        return [
            ExtensionDeclSyntax(
                extendedType: type,
                inheritanceClause: .init(inheritedTypes: [InheritedTypeSyntax(type: TypeSyntax("SwiftCrossData.Model"))])
            ) {
                """
                public static var properties: [SwiftCrossData.ModelProperty<Self>] {
                    [\(raw: propertyElements)]
                }
                """

                """
                #if !canImport(CoreData)
                public init(row: Row) throws {
                    self.rowid = try decodeRowValue(row, "rowid")
                    \(raw: initStatements)
                }
                #endif
                """
            }
        ]
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return [
            """
            #if !canImport(CoreData)
            var rowid: Int64 = -1
            #endif
            """
        ]
    }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let declaration = declaration.as(StructDeclSyntax.self) else {
            throw DiagnosticError(description: "Models must be structs")
        }

        let str = Struct(declaration)

        let properties = str.properties.filter(\.isStored)
        
        var propertyElements = ""
        for property in properties {
            guard let type = property.type else {
                context.diagnose(Diagnostic(
                    node: property._syntax,
                    message: Message(
                        message: "Could not determine property type.",
                        diagnosticID: MessageID(domain: errorDomain, id: "MissingPropertyType"),
                        severity: .error
                    )
                ))
                continue
            }
            propertyElements += "\n@NSManaged var \(property.identifier): \(type.normalizedDescription)"
            if let initialValue = property.initialValue {
                propertyElements += " = \(initialValue._syntax.description)"
            }
        }
        
        return [
            """
            #if canImport(CoreData)
            final class SCDataModel_\(raw: str.identifier): NSManagedObject {
                \(raw: propertyElements)
            }
            #endif
            """
        ]
    }
}