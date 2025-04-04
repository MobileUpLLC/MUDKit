import Foundation

public struct DeeplinkConfiguration: Sendable {
    let deeplinkHandler: @Sendable (URL) -> Void
    
    public init(deeplinkHandler: @Sendable @escaping (URL) -> Void) {
        self.deeplinkHandler = deeplinkHandler
    }
}
