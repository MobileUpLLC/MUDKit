import Foundation
import os
import Pulse

public struct Log {
    public enum LogEntry {
        case text(String)
        case detailed(text: String, parameters: [AnyHashable: Any])
    }
    
    private let logger: Logger
    private let category: String
    
    public init(subsystem: String, category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
        self.category = category
    }
    
    /// Only during debugging.
    ///
    /// Examples:
    /// 1. Intermediate calculation results for algrorithm.
    ///
    /// Not persisted.
    public func debug(logEntry: LogEntry) {
        log(level: .debug, logEntry: logEntry)
    }
    
    /// Not essential for troubleshooting.
    ///
    /// Examples:
    /// 1. User logged in/logged out.
    /// 2. User changed language/theme/settings.
    ///
    /// Persisted only during log collect
    public func info(logEntry: LogEntry) {
        log(level: .info, logEntry: logEntry)
    }
    
    /// Essential for troubleshooting.
    ///
    /// Examples:
    /// 1. Any server requests, successful responses.
    ///
    /// Persisted up to a storage limit
    public func `default`(logEntry: LogEntry) {
        log(level: .default, logEntry: logEntry)
    }
    
    /// Error during execution.
    ///
    /// Examples:
    /// 1. Server returns error. Error is handled by app, so it's not a bug.
    ///
    /// Persisted up to a storage limit
    public func error(logEntry: LogEntry) {
        log(level: .error, logEntry: logEntry)
    }
    
    /// Bug in program.
    ///
    /// Examples:
    /// 1. Server returns "-1" as user id. From data perspective it's valid, still Int,
    /// but can lead to undefined behavior.
    ///
    /// Persisted up to a storage limit
    public func fault(logEntry: LogEntry) {
        log(level: .fault, logEntry: logEntry)
    }
    
    private func log(level: OSLogType, logEntry: LogEntry) {
        let logMessage = getLogMessage(logEntry: logEntry)
        
        logger.log(level: level, "\(logMessage)")
        
        /// Log to Pulse
        LoggerStore.shared.storeMessage(
            label: category,
            level: level.toLoggerStoreLevel(),
            message: logMessage
        )
    }
    
    private func getLogMessage(logEntry: LogEntry) -> String {
        switch logEntry {
        case .text(let value):
            return value
        case let .detailed(text, parameters):
            return getDetailedLogMessage(text: text, parameters: parameters)
        }
    }
    
    private func getDetailedLogMessage(text: String, parameters: [AnyHashable: Any]) -> String {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return text
        }
        
        let logMessage = """
                        ============MUDKit log message START============
                        \(text)
                        \(jsonString)
                        ============MUDKit log message END============
                        """
        
        return logMessage
    }
}

private extension OSLogType {
    func toLoggerStoreLevel() -> LoggerStore.Level {
        switch self {
        case .default:
            return .info
        case .info:
            return .info
        case .debug:
            return .debug
        case .error:
            return .error
        case .fault:
            return .critical
        default:
            return .info
        }
    }
}
