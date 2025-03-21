import Foundation

extension Log {
    static let userDefaultsUtil = Log(subsystem: subsystem, category: "UserDefaultsUtil")
    
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
}
