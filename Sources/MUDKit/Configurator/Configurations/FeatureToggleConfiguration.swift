import Foundation

public struct FeatureToggleConfiguration {
    let featureToggles: [FeatureToggle]
    
    public init(featureToggles: [FeatureToggle]) {
        self.featureToggles = featureToggles
    }
}

public struct FeatureToggle: Hashable {
    let name: String
    var convenientName: String
    var isEnabled: Bool
    let isLocal: Bool
    
    public init(name: String, convenientName: String, isEnabled: Bool, isLocal: Bool) {
        self.name = name
        self.convenientName = convenientName
        self.isEnabled = isEnabled
        self.isLocal = isLocal
    }
}
