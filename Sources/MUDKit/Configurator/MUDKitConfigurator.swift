public actor MUDKitConfigurator {
    public static var configuration: MUDKitConfiguration? { _configuration }
    
    private static var _configuration: MUDKitConfiguration?
    
    public static func setup(
        pulseConfiguration: PulseConfiguration?,
        featureToggleConfiguration: FeatureToggleConfiguration?
    ) throws -> MUDKitConfiguration {
        _configuration = MUDKitConfiguration(
            pulseSession: pulseConfiguration?.setup(),
            featureToggleConfiguration: featureToggleConfiguration
        )
        
        if let _configuration {
            return _configuration
        } else {
            throw MUDKitError.setupFailed
        }
    }
}
