import SwiftSyntaxMacros
import SwiftSyntax
import SwiftDiagnostics
import MacroToolkit

public enum ModelMacro: MemberMacro, PeerMacro, ExtensionMacro {
    // MARK: Extension Macro
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
        var sqliteInitStatements = ""
        var coreDataInitStatements = ""
        var debugDescriptionPieces: [String] = []

        for property in properties {
            if property.identifier == "debugDescription" {
                continue
            }

            let columnName = property.identifier

            sqliteInitStatements +=
                "self.\(property.identifier) = try SwiftCrossData.decodeRowValue(row, \"\(columnName)\")\n"

            coreDataInitStatements +=
                "self.\(property.identifier) = .fromScalar(managedObject.\(columnName))\n"

            debugDescriptionPieces.append(
                #"\#(property.identifier): \(Swift.String(reflecting: self.\#(property.identifier)))"#
            )

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
                inheritanceClause: .init(inheritedTypes: [
                    InheritedTypeSyntax(type: TypeSyntax("SwiftCrossData.Model"))
                ])
            ) {
                """
                public static var properties: [SwiftCrossData.ModelProperty<Self>] {
                    [\(raw: propertyElements)]
                }
                """

                if !str.properties.contains(where: { $0.identifier == "debugDescription" }) {
                    #"""
                    public var debugDescription: Swift.String {
                        "\(Self.self)(\#(raw: debugDescriptionPieces.joined(separator: ", ")))"
                    }
                    """#
                }

                #if CORE_DATA
                    """
                    public typealias ManagedObjectType = SCDataModel_\(raw: str.identifier)
                    """

                    """
                    public init(managedObject: Self.ManagedObjectType) {
                        self.managedObject = managedObject
                        \(raw: coreDataInitStatements)
                    }
                    """
                #else
                    """
                    public init(row: SwiftCrossData.Row) throws {
                        self.rowid = try SwiftCrossData.decodeRowValue(row, "rowid")
                        \(raw: sqliteInitStatements)
                    }
                    """
                #endif
            }
        ]
    }

    // MARK: Member Macro
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        #if CORE_DATA
            return ["public nonisolated(unsafe) var managedObject: Self.ManagedObjectType? = nil"]
        #else
            return ["public var rowid: Int64 = -1"]
        #endif
    }

    // MARK: Peer Macro
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        #if CORE_DATA
            guard let declaration = declaration.as(StructDeclSyntax.self) else {
                throw DiagnosticError(description: "Models must be structs")
            }

            let str = Struct(declaration)

            let properties = str.properties.filter(\.isStored)

            var propertyElements = ""
            for property in properties {
                guard let type = property.type else {
                    context.diagnose(
                        Diagnostic(
                            node: property._syntax,
                            message: Message(
                                message: "Could not determine property type.",
                                diagnosticID: MessageID(
                                    domain: errorDomain,
                                    id: "MissingPropertyType"
                                ),
                                severity: .error
                            )
                        )
                    )
                    continue
                }
                propertyElements +=
                    "\n@NSManaged var \(property.identifier): \(type.normalizedDescription).ScalarType"
            }

            return [
                """
                \(raw: str.accessLevel?.name ?? "") final class \
                SCDataModel_\(raw: str.identifier): NSManagedObject {
                    \(raw: propertyElements)
                }
                """
            ]
        #else
            return []
        #endif
    }
}
