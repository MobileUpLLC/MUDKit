import Foundation

enum UserDefaultsService {
    static func set<T: Encodable>(value: T, for key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            Log.userDefaultsService.error(logEntry: .text("Unable to encode value for key \(key): \(error)"))
        }
    }
    
    static func get<T: Decodable>(for key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            let item = try? JSONDecoder().decode(T.self, from: data)
            
            return item
        }
        
        return nil
    }
    
    static func delete(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func clear() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach { delete(for: $0) }
    }
}
