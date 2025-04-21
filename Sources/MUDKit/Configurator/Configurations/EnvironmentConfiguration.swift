import Foundation

/// Configuration for managing multiple environments (e.g., dev, prod).
public struct EnvironmentConfiguration: Sendable {
    /// List of available environments.
    let environments: [Environment]
    /// The id of the default environment.
    let defaultEnvironmentId: UUID
    /// The currently selected environment, if any.
    let selectedEnvironment: Environment?
    
    /// Initializes the environment configuration.
    /// - Parameters:
    ///   - environments: An array of `Environment` objects representing available environments.
    ///   - defaultEnvironmentId: The id of the default environment to use if none was selected.
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
