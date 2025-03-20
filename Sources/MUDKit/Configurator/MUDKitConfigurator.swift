public struct MUDKitConfigurator {
    public static func setup(
        pulseConfiguration: PulseConfiguration?,
        featureToggleConfiguration: FeatureToggleConfiguration?
    ) -> MUDKitConfiguration {
        return MUDKitConfiguration(
            pulseSession: pulseConfiguration?.setup(),
            featureToggleConfiguration: featureToggleConfiguration
        )
    }
}
