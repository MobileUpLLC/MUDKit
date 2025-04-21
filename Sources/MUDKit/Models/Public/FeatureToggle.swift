/// Represents a feature toggle.
public struct FeatureToggle: Hashable, Codable, Sendable {
    let name: String
    let convenientName: String
    var isEnabled: Bool
    
    public init(name: String, convenientName: String, isEnabled: Bool) {
        self.name = name
        self.convenientName = convenientName
        self.isEnabled = isEnabled
    }
}
