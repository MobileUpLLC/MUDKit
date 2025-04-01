public struct Environment: Codable, Hashable, Sendable {
    let name: String
    let parameters: [String: String]
    
    public init(name: String, parameters: [String: String]) {
        self.name = name
        self.parameters = parameters
    }
}
