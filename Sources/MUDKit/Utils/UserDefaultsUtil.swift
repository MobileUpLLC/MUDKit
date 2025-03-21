import Foundation

enum UserDefaultsUtil {
    public static func save<T: Encodable>(value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            Log.userDefaultsUtil.error(logEntry: .text("Unable to encode value for key \(key): \(error)"))
        }
    }
    
    public static func get<T: Decodable>(for key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            let item = try? JSONDecoder().decode(T.self, from: data)
            
            return item
        }
        
        return nil
    }
}
