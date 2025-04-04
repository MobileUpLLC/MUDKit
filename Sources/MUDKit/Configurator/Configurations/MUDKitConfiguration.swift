import Foundation

public struct MUDKitConfiguration: Sendable {
    public let pulseSession: URLSession?
    public let featureToggleConfiguration: FeatureToggleConfiguration?
    public let deeplinkConfiguration: DeeplinkConfiguration?
    
    static let empty = MUDKitConfiguration(
        pulseSession: nil,
        featureToggleConfiguration: nil,
        deeplinkConfiguration: nil
    )
    
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
