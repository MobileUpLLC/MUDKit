/// Тип ответственный за хранение ключей, используемых при CRUD операциях с UserDefaults или Keychain.
enum Key: String {
    case isOverrideBaseConfig
    case featureToggles
    case environments
    case selectedEnvironment
    case defaultEnvironmentName
}
