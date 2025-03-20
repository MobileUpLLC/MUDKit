import Foundation

public struct MUDKitConfiguration {
    public let pulseSession: URLSession?
    public let featureToggleConfiguration: FeatureToggleConfiguration?
    
    public init(pulseSession: URLSession?, featureToggleConfiguration: FeatureToggleConfiguration?) {
        self.pulseSession = pulseSession
        self.featureToggleConfiguration = featureToggleConfiguration
    }
}
