/// Represents a feature toggle with a name and enabled state.
public struct FeatureToggle: Hashable, Codable, Sendable {
    /// The unique identifier for the feature toggle.
    let name: String
    /// A user-friendly name for the feature toggle.
    let convenientName: String
    /// Whether the feature is enabled.
    var isEnabled: Bool
    
    /// Initializes a feature toggle.
        /// - Parameters:
        ///   - name: The unique identifier for the toggle.
        ///   - convenientName: A user-friendly name for the toggle.
        ///   - isEnabled: Whether the feature is enabled.
    public init(name: String, convenientName: String, isEnabled: Bool) {
        self.name = name
        self.convenientName = convenientName
        self.isEnabled = isEnabled
    }
}
