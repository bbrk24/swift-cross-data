import SwiftSyntaxMacros
import SwiftSyntax
import SwiftDiagnostics
import MacroToolkit

public enum ModelMacro: MemberMacro, PeerMacro, ExtensionMacro {
    // Properties and zero-argument methods of NSManagedObject (and its superclass, NSObject)
    // cannot be column names due to CoreData limitations. Because extensions can add whatever it's
    // impossible for a macro to detect them all, but here's a list of things that may conflict.
    static let objcInvalidColumnNames: Set<String> = [
        // NSObjectProtocol
        "hash", "self", "isProxy", "retain", "release", "autorelease", "retainCount", "zone",
        "class", "superclass", "description", "debugDescription",
        // NSObject
        "init", "copy", "mutableCopy", "dealloc", "autoContentAccessingProxy",
        "classForArchiver", "classForCoder", "classForKeyedArchiver", "attributeKeys",
        "classDescription", "toManyRelationshipKeys", "toOneRelationshipKeys", "classCode",
        "className", "browserAccessibilitySelectedTextRange", "browserAccessibilityContainerType",
        "browserAccessibilityCurrentStatus", "browserAccessibilityHasDOMFocus",
        "browserAccessibilityIsRequired", "browserAccessibilityPressedState",
        "browserAccessibilityRoleDescription", "browserAccessibilitySortDirection",
        "accessibilityNotifiesWhenDestroyed", "objectSpecifier", "actionProperty", "awakeFromNib",
        "imageRepresentation", "imageRepresentationType", "imageSubtitle", "imageTitle", "imageUID",
        "imageVersion",
        // UIAccessibilityAction
        "accessibilityActivate", "accessibilityIncrement", "accessibilityDecrement",
        "accessibilityPerformEscape", "accessibilityPerformMagicTap", "accessibilityCustomActions",
        // UIAccessibilityFocus
        "accessibilityElementDidBecomeFocused", "accessibilityElementDidLoseFocus",
        "accessibilityElementIsFocused", "accessibilityAssistiveTechnologyFocusedIdentifiers",
        // UIAccessibilityDragging
        "accessibilityDragSourceDescriptors", "accessibilityDropPointDescriptors",
        // NSKeyValueObserving
        "observationInfo",
        // NSKeyValueBindingCreation
        "exposedBindings",
        // WebPlugInContainer
        "webFrame", "webPlugInContainerSelectionColor",
        // WebPlugIn
        "objectForWebScript", "webPlugInDestroy", "webPlugInInitialize", "webPlugInStart",
        "webPlugInStop", "webPlugInMainResourceDidFinishLoading",
        // WebScripting
        "finalizeForWebScript",
        // NSManagedObject
        "entity", "objectID", "managedObjectContext", "hasChanges", "isInserted", "isUpdated",
        "isDeleted", "isFault", "faultingState", "hasPersistentChangedValues", "awakeFromFetch",
        "awakeFromInsert", "changedValues", "changedValuesForCurrentEvent", "prepareForDeletion",
        "willSave", "didSave", "willTurnIntoFault", "didTurnIntoFault", "validateForDelete",
        "validateForInsert", "validateForUpdate", "observationInfo",
        // big undocumented blob at the bottom of the NSObject page
        "accessibilityActivateBlock", "accessibilityActivationPoint",
        "accessibilityActivationPointBlock", "accessibilityAttributedHint",
        "accessibilityAttributedHintBlock", "accessibilityAttributedLabel",
        "accessibilityAttributedLabelBlock", "accessibilityAttributedUserInputLabels",
        "accessibilityAttributedUserInputLabelsBlock", "accessibilityAttributedValue",
        "accessibilityAttributedValueBlock", "accessibilityContainerType",
        "accessibilityContainerTypeBlock", "accessibilityCustomActionsBlock",
        "accessibilityCustomRotors", "accessibilityCustomRotorsBlock",
        "accessibilityDecrementBlock", "accessibilityDirectTouchOptions", "accessibilityElements",
        "accessibilityElementsBlock", "accessibilityElementsHidden",
        "accessibilityElementsHiddenBlock", "accessibilityExpandedStatus",
        "accessibilityExpandedStatusBlock", "accessibilityFocusedUIElement", "accessibilityFrame",
        "accessibilityFrameBlock", "accessibilityHeaderElements",
        "accessibilityHeaderElementsBlock", "accessibilityHint", "accessibilityHintBlock",
        "accessibilityIdentifierBlock", "accessibilityIncrementBlock", "accessibilityLabel",
        "accessibilityLabelBlock", "accessibilityLanguage", "accessibilityLanguageBlock",
        "accessibilityMagicTapBlock", "accessibilityNavigationStyle",
        "accessibilityNavigationStyleBlock", "accessibilityNextTextNavigationElement",
        "accessibilityNextTextNavigationElementBlock", "accessibilityPath",
        "accessibilityPathBlock", "accessibilityPerformEscapeBlock",
        "accessibilityPreviousTextNavigationElement",
        "accessibilityPreviousTextNavigationElementBlock", "accessibilityRespondsToUserInteraction",
        "accessibilityRespondsToUserInteractionBlock",
        "accessibilityShouldGroupAccessibilityChildrenBlock", "accessibilityTextInputResponder",
        "accessibilityTextInputResponderBlock", "accessibilityTextualContext",
        "accessibilityTextualContextBlock", "accessibilityTraits", "accessibilityTraitsBlock",
        "accessibilityUserInputLabels", "accessibilityUserInputLabelsBlock", "accessibilityValue",
        "accessibilityValueBlock", "accessibilityViewIsModal", "accessibilityViewIsModalBlock",
        "automationElements", "automationElementsBlock", "isAccessibilityElement",
        "isAccessibilityElementBlock", "isSelectable", "shouldGroupAccessibilityChildren",
        "accessibilityElementCount", "accessibilityLineEndPositionFromCurrentSelection",
        "accessibilityLineStartPositionFromCurrentSelection",
    ]

    static func isValidCIdentifier(_ str: String) -> Bool {
        // Taken from https://learn.microsoft.com/en-us/cpp/c-language/lexical-grammar because it's
        // the most accessible C grammar I could find
        let validIdStart: Set<Character> = Set(
            "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        )
        let validIdChar: Set<Character> = validIdStart.union(Set("0123456789"))
        let cKeywords: Set<String> = [
            "auto", "break", "case", "char", "const", "continue", "default", "do", "double", "else",
            "enum", "extern", "float", "for", "goto", "if", "inline", "int", "long", "register",
            "restrict", "return", "short", "signed", "sizeof", "static", "struct", "switch",
            "typedef", "union", "unsigned", "void", "volatile", "while", "_Alignas", "_Alignof",
            "_Atomic", "_Bool", "_Complex", "_Generic", "_Imaginary", "_Noreturn", "_Static_assert",
            "_Thread_local",
        ]

        return !str.isEmpty && !cKeywords.contains(str)
            && str.allSatisfy(validIdChar.contains(_:))
            && validIdStart.contains(str.first!)
    }

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
            var propertyName = property.identifier
            if propertyName.first == "`" && propertyName.last == "`" {
                propertyName.removeFirst()
                propertyName.removeLast()
            }

            if propertyName == "debugDescription" {
                continue
            }

            let columnName = propertyName

            if objcInvalidColumnNames.contains(columnName) {
                context.diagnose(
                    Diagnostic(
                        node: property._syntax,
                        message: Message(
                            message:
                                "Column name cannot be a property or zero-argument method of NSManagedObject",
                            diagnosticID: MessageID(
                                domain: errorDomain,
                                id: "NSManagedObjectSelectorConflict"
                            ),
                            severity: .error
                        )
                    )
                )
            } else if !isValidCIdentifier(columnName) {
                context.diagnose(
                    Diagnostic(
                        node: property._syntax,
                        message: Message(
                            message:
                                "Column name must be a valid C identifier",
                            diagnosticID: MessageID(
                                domain: errorDomain,
                                id: "InvalidCIdentifier"
                            ),
                            severity: .error
                        )
                    )
                )
            }

            sqliteInitStatements +=
                "self.`\(propertyName)` = try SwiftCrossData.decodeRowValue(row, \"\(columnName)\")\n"

            coreDataInitStatements +=
                "self.`\(propertyName)` = .fromScalar(managedObject.`\(columnName)`)\n"

            debugDescriptionPieces.append(
                #"\#(propertyName): \(Swift.String(reflecting: self.`\#(propertyName)`))"#
            )

            if let initialValue = property.initialValue {
                propertyElements += #"""
                    .init(
                        keyPath: \\#(str.identifier).`\#(propertyName)`,
                        columnName: "\#(columnName)",
                        defaultValue: \#(initialValue._syntax.description)
                    ),
                    """#
            } else {
                propertyElements += #"""
                    .init(
                        keyPath: \\#(str.identifier).`\#(propertyName)`,
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
                var propertyName = property.identifier
                if propertyName.first == "`" && propertyName.last == "`" {
                    propertyName.removeFirst()
                    propertyName.removeLast()
                }

                if propertyName == "debugDescription" {
                    continue
                }

                let columnName = propertyName

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
                    "\n@NSManaged var `\(columnName)`: \(type.normalizedDescription).ScalarType"
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
