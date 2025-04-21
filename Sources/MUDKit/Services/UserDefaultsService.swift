import Foundation

/// Utility for managing UserDefaults storage.
enum UserDefaultsService {
    /// Saves an encodable value to UserDefaults.
        /// - Parameters:
        ///   - value: The value to save, conforming to `Encodable`.
        ///   - key: The key under which to store the value.
    static func set<T: Encodable>(value: T, for key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            Log.userDefaultsService.error(logEntry: .text("Unable to encode value for key \(key): \(error)"))
        }
    }
    
    /// Retrieves a decodable value from UserDefaults.
        /// - Parameter key: The key for the value.
        /// - Returns: The decoded value of type `T`, or `nil` if not found or decoding fails.
    static func get<T: Decodable>(for key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            let item = try? JSONDecoder().decode(T.self, from: data)
            
            return item
        }
        
        return nil
    }
    
    /// Deletes a value from UserDefaults.
        /// - Parameter key: The key of the value to delete.
    static func delete(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// Clears all data from UserDefaults.
    static func clear() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach { delete(for: $0) }
    }
}
