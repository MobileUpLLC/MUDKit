public actor MUDKitConfigurator {
    public static var configuration: MUDKitConfiguration?
    
    public static func setup(
        pulseConfiguration: PulseConfiguration?,
        featureToggleConfiguration: FeatureToggleConfiguration?
    ) throws -> MUDKitConfiguration {
        configuration = MUDKitConfiguration(
            pulseSession: pulseConfiguration?.setup(),
            featureToggleConfiguration: getFeatureToggleConfiguration(featureToggleConfiguration)
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
            let isOverrideBaseConfig: Bool = UserDefaultsUtil.get(for: "isOverrideBaseConfig"),
            isOverrideBaseConfig,
            let featureToggles: [FeatureToggle] = UserDefaultsUtil.get(for: "featureToggles")
        {
            return FeatureToggleConfiguration(featureToggles: featureToggles)
        } else {
            return featureToggleConfiguration
        }
    }
}
