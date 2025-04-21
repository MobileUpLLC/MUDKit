import Foundation

/// The main configuration for MUDKit, combining settings for various features.
public struct MUDKitConfiguration: Sendable {
    /// The URL session for Pulse network logging, if configured.
    public let pulseSession: URLSession?
    /// The configuration for feature toggles, if set.
    public let featureToggleConfiguration: FeatureToggleConfiguration?
    /// The configuration for deeplink handling, if set.
    public let deeplinkConfiguration: DeeplinkConfiguration?
    /// The configuration for environments, if set.
    public let environmentConfiguration: EnvironmentConfiguration?
    
    /// An empty configuration with all properties set to `nil`.
    static let empty = MUDKitConfiguration(
        pulseSession: nil,
        featureToggleConfiguration: nil,
        deeplinkConfiguration: nil,
        environmentConfiguration: nil
    )
    
    /// Initializes the MUDKit configuration with provided settings.
        /// - Parameters:
        ///   - pulseSession: The URL session for Pulse logging. Optional.
        ///   - featureToggleConfiguration: Configuration for feature toggles. Optional.
        ///   - deeplinkConfiguration: Configuration for deeplink handling. Optional.
        ///   - environmentConfiguration: Configuration for environments. Optional.
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
