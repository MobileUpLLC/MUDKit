import Foundation

/// Configuration for handling deeplinks in the application.
public struct DeeplinkConfiguration: Sendable {
    let deeplinkHandler: @Sendable (URL) -> Void
    
    public init(deeplinkHandler: @Sendable @escaping (URL) -> Void) {
        self.deeplinkHandler = deeplinkHandler
    }
}
