import Foundation

/// Configuration for managing multiple environments (e.g., dev, prod).
public struct MUDEnvironmentConfiguration: Sendable {
    public let selectedEnvironment: Environment?

    let environments: [Environment]
    let defaultEnvironmentId: UUID

    public init(
        environments: [Environment],
        defaultEnvironmentId: UUID
    ) {
        self.environments = environments
        self.defaultEnvironmentId = defaultEnvironmentId
        
        if
            let selectedEnvironment: Environment = UserDefaultsService.get(for: Key.selectedEnvironment.rawValue),
            environments.contains(selectedEnvironment)
        {
            self.selectedEnvironment = selectedEnvironment
        } else {
            self.selectedEnvironment = environments.first { $0.id == defaultEnvironmentId }
        }
    }
}
