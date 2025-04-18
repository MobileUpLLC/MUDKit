import Foundation

extension Log {
    static let userDefaultsService = Log(subsystem: subsystem, category: "UserDefaultsService")
    static let fileSystemService = Log(subsystem: subsystem, category: "FileSystemService")
    
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
}
