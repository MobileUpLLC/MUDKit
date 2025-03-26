import Foundation

public struct MUDKitConfiguration: Sendable {
    public let pulseSession: URLSession?
    public let featureToggleConfiguration: FeatureToggleConfiguration?
    
    static let empty = MUDKitConfiguration(pulseSession: nil, featureToggleConfiguration: nil)
    
    public init(pulseSession: URLSession?, featureToggleConfiguration: FeatureToggleConfiguration?) {
        self.pulseSession = pulseSession
        self.featureToggleConfiguration = featureToggleConfiguration
    }
}
