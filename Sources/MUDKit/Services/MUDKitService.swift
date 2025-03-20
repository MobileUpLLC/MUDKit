public struct MUDKitService {
    public static func isFeatureToggleOn(name: String) -> Bool {
        return MUDKitConfigurator
            .configuration?
            .featureToggleConfiguration?
            .featureToggles
            .filter { $0.isEnabled && $0.name == name } != nil
    }
}
