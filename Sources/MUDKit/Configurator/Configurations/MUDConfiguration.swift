import Foundation

/// The main configuration for MUDKit, combining settings for various features.
public struct MUDConfiguration: Sendable {
    public let pulseSession: URLSession?
    public let featureToggleConfiguration: FeatureToggleConfiguration?
    public let deeplinkConfiguration: DeeplinkConfiguration?
    public let environmentConfiguration: MUDEnvironmentConfiguration?
    
    static let empty = MUDConfiguration(
        pulseSession: nil,
        featureToggleConfiguration: nil,
        deeplinkConfiguration: nil,
        environmentConfiguration: nil
    )
    
    public init(
        pulseSession: URLSession?,
        featureToggleConfiguration: FeatureToggleConfiguration?,
        deeplinkConfiguration: DeeplinkConfiguration?,
        environmentConfiguration: MUDEnvironmentConfiguration?
    ) {
        self.pulseSession = pulseSession
        self.featureToggleConfiguration = featureToggleConfiguration
        self.deeplinkConfiguration = deeplinkConfiguration
        self.environmentConfiguration = environmentConfiguration
    }
}
