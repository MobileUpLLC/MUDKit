/// Тип ответственный за хранение ключей, используемых при CRUD операциях с UserDefaults или Keychain.
enum Key: String {
    case isOverrideBaseConfig
    case featureToggles
    case frameGeometry
    case selectedEnvironment
}
