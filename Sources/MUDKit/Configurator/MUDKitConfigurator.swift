public struct MUDKitConfigurator {
    public static func setup(pulseConfiguration: PulseConfiguration?) -> MUDKitConfiguration {
        return MUDKitConfiguration(pulseSession: pulseConfiguration?.setup())
    }
}
