import Foundation

/// Configuration for managing feature toggles in the application.
public struct FeatureToggleConfiguration: Sendable {
    /// List of feature toggles.
    let featureToggles: [FeatureToggle]
    
    /// Initializes the feature toggle configuration.
    /// - Parameter featureToggles: An array of `FeatureToggle` objects.
    public init(featureToggles: [FeatureToggle]) {
        self.featureToggles = featureToggles
    }
}
