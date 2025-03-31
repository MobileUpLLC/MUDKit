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
            environmentConfiguration: getEnvironmentConfiguration(environmentConfiguration)
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
    
    private static func getEnvironmentConfiguration(
        _ environmentConfiguration: EnvironmentConfiguration?
    ) -> EnvironmentConfiguration? {
        guard let environmentConfiguration else {
            if
                let environments: [Environment] = UserDefaultsService.get(for: "environments"),
                let defaultEnvironmentName: String = UserDefaultsService.get(for: "defaultEnvironmentName")
            {
                return EnvironmentConfiguration(
                    environments: environments,
                    defaultEnvironmentName: defaultEnvironmentName
                )
            } else {
                return nil
            }
        }
        
        UserDefaultsService.set(value: environmentConfiguration.environments, for: "environments")
        UserDefaultsService.set(value: environmentConfiguration.defaultEnvironmentName, for: "defaultEnvironmentName")
        
        return environmentConfiguration
    }
}
