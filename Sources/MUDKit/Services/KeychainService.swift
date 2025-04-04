import KeychainSwift

struct KeychainService {
    static func clear() {
        KeychainSwift().clear()        
    }
    
    static func delete(for key: String) {
        KeychainSwift().delete(key)
    }
}
