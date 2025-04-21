/// Enum for keys used in UserDefaults or Keychain CRUD operations.
enum Key: String {
    /// Key for overriding the base configuration.
    case isOverrideBaseConfig
    /// Key for storing feature toggles.
    case featureToggles
    /// Key for storing frame geometry enabled flag.
    case frameGeometry
    /// Key for storing the selected environment.
    case selectedEnvironment
}
