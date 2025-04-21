import Foundation

/// Represents an environment configuration with id, name and parameters.
public struct Environment: Codable, Hashable, Identifiable, Sendable {
    /// The UUID of the environment.
    public let id: UUID
    /// The name of the environment (e.g., "dev", "prod").
    let name: String
    /// A dictionary of environment-specific parameters.
    let parameters: [String: String]
    
    /// Initializes an environment with a name and parameters.
        /// - Parameters:
        ///   - id: The UUID of the environment.
        ///   - name: The name of the environment.
        ///   - parameters: A dictionary of key-value pairs for environment settings.
    public init(id: UUID, name: String, parameters: [String: String]) {
        self.id = id
        self.name = name
        self.parameters = parameters
    }
}
