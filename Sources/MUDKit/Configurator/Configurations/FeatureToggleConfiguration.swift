import Foundation

public struct FeatureToggleConfiguration {
    public let featureToggles: [FeatureToggle]
}

public struct FeatureToggle: Hashable {
    public let name: String
    public var convenientName: String
    public var isEnabled: Bool
    public let isLocal: Bool
}
