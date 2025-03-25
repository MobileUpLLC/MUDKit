public actor MUDKitConfigurator {
    private enum Constants {
        static let isOverrideBaseConfigKey = "isOverrideBaseConfig"
        static let featureToggles = "featureToggles"
    }
    
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
            let isOverrideBaseConfig: Bool = UserDefaultsUtil.get(for: Constants.isOverrideBaseConfigKey),
            isOverrideBaseConfig,
            let featureToggles: [FeatureToggle] = UserDefaultsUtil.get(for: Constants.featureToggles)
        {
            return FeatureToggleConfiguration(featureToggles: featureToggles)
        } else {
            return featureToggleConfiguration
        }
    }
}
