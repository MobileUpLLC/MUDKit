import Foundation

public struct FeatureToggleConfiguration {
    let featureToggles: [FeatureToggle]
    
    public init(featureToggles: [FeatureToggle]) {
        self.featureToggles = featureToggles
    }
}

public struct FeatureToggle: Hashable, Codable {
    let name: String
    var convenientName: String
    var isEnabled: Bool
    
    public init(name: String, convenientName: String, isEnabled: Bool) {
        self.name = name
        self.convenientName = convenientName
        self.isEnabled = isEnabled
    }
}
