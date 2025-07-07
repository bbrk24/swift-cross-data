import SwiftDiagnostics

struct DiagnosticError: Error, CustomStringConvertible {
    var description: String
}

struct Message: DiagnosticMessage {
    var message: String
    var diagnosticID: MessageID
    var severity: DiagnosticSeverity
}

let errorDomain = "SwiftCoreDataErrorDomain"
