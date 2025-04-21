import Foundation
import os
import Pulse

/// A logging utility with support for different log levels and Pulse integration.
public struct Log: Sendable {
    /// Enum representing log entry types.
    public enum LogEntry {
        /// A simple text-based log entry.
        case text(String)
        /// A detailed log entry with text and JSON-serializable parameters.
        case detailed(text: String, parameters: [AnyHashable: Any])
    }
    
    private let logger: Logger
    private let category: String
    private let isLoggingNeeded: Bool
    
    /// Initializes a logger.
        /// - Parameters:
        ///   - subsystem: The subsystem identifier (e.g., app bundle ID).
        ///   - category: The category for organizing logs.
        ///   - isLoggingNeeded: Whether logging is enabled. Defaults to `true`.
    public init(subsystem: String, category: String, isLoggingNeeded: Bool = true) {
        self.logger = Logger(subsystem: subsystem, category: category)
        self.category = category
        self.isLoggingNeeded = isLoggingNeeded
    }
    
    /// Logs a debug-level message.
        /// - Parameter logEntry: The log entry to record.
    public func debug(logEntry: LogEntry) {
        log(level: .debug, logEntry: logEntry)
    }
    
    /// Logs an info-level message.
        /// - Parameter logEntry: The log entry to record.
    public func info(logEntry: LogEntry) {
        log(level: .info, logEntry: logEntry)
    }
    
    /// Logs a default-level message.
        /// - Parameter logEntry: The log entry to record.
    public func `default`(logEntry: LogEntry) {
        log(level: .default, logEntry: logEntry)
    }
    
    /// Logs an error-level message.
        /// - Parameter logEntry: The log entry to record.
    public func error(logEntry: LogEntry) {
        log(level: .error, logEntry: logEntry)
    }
    
    /// Logs a fault-level message.
        /// - Parameter logEntry: The log entry to record.
    public func fault(logEntry: LogEntry) {
        log(level: .fault, logEntry: logEntry)
    }
    
    private func log(level: OSLogType, logEntry: LogEntry) {
        guard isLoggingNeeded else {
            return
        }
        
        let logMessage = getLogMessage(logEntry: logEntry)
        
        logger.log(level: level, "\(logMessage)")
        
        // Log to Pulse
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
                        ============MUDKit log message END==============
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
