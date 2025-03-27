import Foundation

public struct MUDKitConfiguration {
    public let pulseSession: URLSession?
    public let featureToggleConfiguration: FeatureToggleConfiguration?
    public let deeplinkConfiguration: DeeplinkConfiguration?
    
    public init(
        pulseSession: URLSession?,
        featureToggleConfiguration: FeatureToggleConfiguration?,
        deeplinkConfiguration: DeeplinkConfiguration?
    ) {
        self.pulseSession = pulseSession
        self.featureToggleConfiguration = featureToggleConfiguration
        self.deeplinkConfiguration = deeplinkConfiguration
    }
}
