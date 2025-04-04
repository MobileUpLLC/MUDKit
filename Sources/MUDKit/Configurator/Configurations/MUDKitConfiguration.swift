import Foundation

public struct MUDKitConfiguration: Sendable {
    public let pulseSession: URLSession?
    public let featureToggleConfiguration: FeatureToggleConfiguration?
    public let deeplinkConfiguration: DeeplinkConfiguration?
    public let environmentConfiguration: EnvironmentConfiguration?
    
    static let empty = MUDKitConfiguration(
        pulseSession: nil,
        featureToggleConfiguration: nil,
        deeplinkConfiguration: nil,
        environmentConfiguration: nil
    )
    
    public init(
        pulseSession: URLSession?,
        featureToggleConfiguration: FeatureToggleConfiguration?,
        deeplinkConfiguration: DeeplinkConfiguration?,
        environmentConfiguration: EnvironmentConfiguration?
    ) {
        self.pulseSession = pulseSession
        self.featureToggleConfiguration = featureToggleConfiguration
        self.deeplinkConfiguration = deeplinkConfiguration
        self.environmentConfiguration = environmentConfiguration
    }
}
