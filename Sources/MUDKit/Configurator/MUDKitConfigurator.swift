/// Для конфигуратора используется actor, так как компилятор требует  изолировать изменяемое свойство configuration.
public actor MUDKitConfigurator {
    public static var configuration: MUDKitConfiguration?
    
    public static func setup(
        pulseConfiguration: PulseConfiguration?,
        featureToggleConfiguration: FeatureToggleConfiguration?
    ) -> MUDKitConfiguration {
        configuration = MUDKitConfiguration(
            pulseSession: pulseConfiguration?.setup(),
            featureToggleConfiguration: resolveActualFeatureToggleConfiguration(featureToggleConfiguration)
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
