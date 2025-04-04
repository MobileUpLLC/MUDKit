import Foundation

public struct FeatureToggleConfiguration: Sendable {
    let featureToggles: [FeatureToggle]
    
    public init(featureToggles: [FeatureToggle]) {
        self.featureToggles = featureToggles
    }
}
