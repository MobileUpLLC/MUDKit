/// Для конфигуратора используется actor, так как компилятор требует  изолировать изменяемое свойство configuration.
public actor MUDKitConfigurator {
    public static var configuration: MUDKitConfiguration?
    
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
            environmentConfiguration: resolveActualEnvironmentConfiguration(environmentConfiguration)
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
