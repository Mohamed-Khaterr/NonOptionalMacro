import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct NonOptionalPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NonOptionalInitializer.self,
    ]
}
