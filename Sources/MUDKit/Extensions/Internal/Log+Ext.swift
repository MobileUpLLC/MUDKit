import Foundation

extension Log {
    static let userDefaultsService = Log(subsystem: subsystem, category: "UserDefaultsService")
    
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
}
