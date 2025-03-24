import KeychainSwift

struct KeychainService {
    static func clear() {
        KeychainSwift().clear()        
    }
}
