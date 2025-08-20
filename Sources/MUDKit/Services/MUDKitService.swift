/// Utility for interacting with MUDKit features.
public enum MUDKitService {
    /// Checks if a feature toggle is enabled.
    /// - Parameter name: The name of the feature toggle to check.
    /// - Returns: `true` if the feature toggle is enabled, `false` otherwise.
    @MainActor
    public static func isFeatureToggleOn(name: String) -> Bool {
        return MUDKitConfigurator
            .configuration?
            .featureToggleConfiguration?
            .featureToggles
            .contains { $0.isEnabled && $0.name == name } ?? false
    }
}
