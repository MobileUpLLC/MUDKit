import Foundation

/// Configuration for handling deeplinks in the application.
public struct DeeplinkConfiguration: Sendable {
    /// A closure to handle deeplink URLs.
    let deeplinkHandler: @Sendable (URL) -> Void
    
    /// Initializes the deeplink configuration with a handler closure.
        /// - Parameter deeplinkHandler: A closure that processes a deeplink URL.
    public init(deeplinkHandler: @Sendable @escaping (URL) -> Void) {
        self.deeplinkHandler = deeplinkHandler
    }
}
