/// A thread-safe configurator for setting up MUDKit with various configurations.
public actor MUDKitConfigurator {
    public static var configuration: MUDKitConfiguration?
    
    /// Configures MUDKit with provided settings and returns the resulting configuration.
        /// - Parameters:
        ///   - pulseConfiguration: Configuration for Pulse network logging. Optional.
        ///   - featureToggleConfiguration: Configuration for feature toggles. Optional.
        ///   - deeplinkConfiguration: Configuration for handling deeplinks. Optional.
        ///   - environmentConfiguration: Configuration for environment settings. Optional.
        /// - Returns: The configured `MUDKitConfiguration` or an empty configuration if setup fails.
    public static func setup(
        pulseConfiguration: PulseConfiguration?,
        featureToggleConfiguration: FeatureToggleConfiguration?,
        deeplinkConfiguration: DeeplinkConfiguration?,
        environmentConfiguration: EnvironmentConfiguration?
    ) -> MUDKitConfiguration {
        configuration = MUDKitConfiguration(
            pulseSession: pulseConfiguration?.setup(),
            featureToggleConfiguration: resolveActualFeatureToggleConfiguration(featureToggleConfiguration),
            deeplinkConfiguration: deeplinkConfiguration,
            environmentConfiguration: environmentConfiguration
        )
        
        return configuration ?? .empty
    }
    
    private static func resolveActualFeatureToggleConfiguration(
        _ featureToggleConfiguration: FeatureToggleConfiguration?
    ) -> FeatureToggleConfiguration? {
        guard let featureToggleConfiguration else {
            return nil
        }
        
        if
            UserDefaultsService.get(for: Key.isOverrideBaseConfig.rawValue) == true,
            let featureToggles: [FeatureToggle] = UserDefaultsService.get(for: Key.featureToggles.rawValue)
        {
            return FeatureToggleConfiguration(featureToggles: featureToggles)
        } else {
            return featureToggleConfiguration
        }
    }
}
