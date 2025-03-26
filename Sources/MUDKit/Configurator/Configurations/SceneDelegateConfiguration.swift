import UIKit

public struct SceneDelegateConfiguration {
    public var options: UIScene.ConnectionOptions?
    public var contexts: Set<UIOpenURLContext>?
    
    public init(options: UIScene.ConnectionOptions? = nil, contexts: Set<UIOpenURLContext>? = nil) {
        self.options = options
        self.contexts = contexts
    }
}
