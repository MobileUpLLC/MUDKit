import Foundation

/// Represents an environment configuration.
public struct Environment: Codable, Hashable, Identifiable, Sendable {
    public let id: UUID
    let name: String
    let parameters: [String: String]
    
    public init(id: UUID, name: String, parameters: [String: String]) {
        self.id = id
        self.name = name
        self.parameters = parameters
    }
}
