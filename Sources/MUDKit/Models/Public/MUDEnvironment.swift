import Foundation

/// Represents an environment configuration.
public struct MUDEnvironment: Codable, Hashable, Identifiable, Sendable {
    public let id: UUID
    public let parameters: [String: String]

    let name: String
    
    public init(id: UUID, name: String, parameters: [String: String]) {
        self.id = id
        self.name = name
        self.parameters = parameters
    }
}
