import Foundation

public struct DeeplinkConfiguration {
    let deeplinkHandler: (URL) -> Void
    
    public init(deeplinkHandler: @escaping (URL) -> Void) {
        self.deeplinkHandler = deeplinkHandler
    }
}
