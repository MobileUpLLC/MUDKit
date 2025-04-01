public actor MUDKitConfigurator {
    public static var configuration: MUDKitConfiguration?
    
    public static func setup(
        pulseConfiguration: PulseConfiguration?,
        featureToggleConfiguration: FeatureToggleConfiguration?,
        deeplinkConfiguration: DeeplinkConfiguration?,
        environmentConfiguration: EnvironmentConfiguration?
    ) throws -> MUDKitConfiguration {
        configuration = MUDKitConfiguration(
            pulseSession: pulseConfiguration?.setup(),
            featureToggleConfiguration: getFeatureToggleConfiguration(featureToggleConfiguration),
            deeplinkConfiguration: deeplinkConfiguration,
            environmentConfiguration: resolveActualEnvironmentConfiguration(environmentConfiguration)
        )
        
        if let configuration {
            return configuration
        } else {
            throw MUDKitError.setupFailed
        }
    }
    
    private static func getFeatureToggleConfiguration(
        _ featureToggleConfiguration: FeatureToggleConfiguration?
    ) -> FeatureToggleConfiguration? {
        guard let featureToggleConfiguration else {
            return nil
        }
        
        if
            let isOverrideBaseConfig: Bool = UserDefaultsService.get(for: "isOverrideBaseConfig"),
            isOverrideBaseConfig,
            let featureToggles: [FeatureToggle] = UserDefaultsService.get(for: "featureToggles")
        {
            return FeatureToggleConfiguration(featureToggles: featureToggles)
        } else {
            return featureToggleConfiguration
        }
    }
    
    private static func resolveActualEnvironmentConfiguration(
        _ environmentConfiguration: EnvironmentConfiguration?
    ) -> EnvironmentConfiguration? {
        guard let environmentConfiguration else {
            if
                let environments: [Environment] = UserDefaultsService.get(for: Key.environments.rawValue),
                let defaultEnvironmentName: String = UserDefaultsService.get(for: Key.defaultEnvironmentName.rawValue)
            {
                return EnvironmentConfiguration(
                    environments: environments,
                    defaultEnvironmentName: defaultEnvironmentName
                )
            } else {
                return nil
            }
        }
        
        UserDefaultsService.set(value: environmentConfiguration.environments, for: Key.environments.rawValue)
        UserDefaultsService.set(value: environmentConfiguration.defaultEnvironmentName, for: Key.defaultEnvironmentName.rawValue)
        
        return environmentConfiguration
    }
}
