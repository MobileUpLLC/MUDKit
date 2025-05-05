import Foundation

/// Configuration for managing feature toggles in the application.
public struct FeatureToggleConfiguration: Sendable {
    let featureToggles: [FeatureToggle]
    
    public init(featureToggles: [FeatureToggle]) {
        self.featureToggles = featureToggles
    }
}
