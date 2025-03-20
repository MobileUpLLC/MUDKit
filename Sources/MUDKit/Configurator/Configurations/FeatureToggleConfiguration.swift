import Foundation

public struct FeatureToggleConfiguration {
    private let featureToggles: [FeatureToggle]
    
    public init(featureToggles: [FeatureToggle]) {
        self.featureToggles = featureToggles
    }
}

public struct FeatureToggle: Hashable {
    private let name: String
    private var convenientName: String
    private var isEnabled: Bool
    private let isLocal: Bool
    
    public init(name: String, convenientName: String, isEnabled: Bool, isLocal: Bool) {
        self.name = name
        self.convenientName = convenientName
        self.isEnabled = isEnabled
        self.isLocal = isLocal
    }
}
