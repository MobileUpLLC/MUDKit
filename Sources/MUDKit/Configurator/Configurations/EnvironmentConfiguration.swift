public struct EnvironmentConfiguration: Sendable {
    let environments: [Environment]
    let defaultEnvironmentName: String
    let selectedEnvironment: Environment?
    
    public init(
        environments: [Environment],
        defaultEnvironmentName: String
    ) {
        self.environments = environments
        self.defaultEnvironmentName = defaultEnvironmentName
        
        if let selectedEnvironment: Environment = UserDefaultsService.get(for: "selectedEnvironment") {
            self.selectedEnvironment = selectedEnvironment
        } else {
            self.selectedEnvironment = environments.first(where: { $0.name == defaultEnvironmentName })
        }
    }
}
