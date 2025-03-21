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
    private let isLoggingNeeded: Bool
    
    public init(subsystem: String, category: String, isLoggingNeeded: Bool = true) {
        self.logger = Logger(subsystem: subsystem, category: category)
        self.category = category
        self.isLoggingNeeded = isLoggingNeeded
    }
    
    public func debug(logEntry: LogEntry) {
        log(level: .debug, logEntry: logEntry)
    }
    
    public func info(logEntry: LogEntry) {
        log(level: .info, logEntry: logEntry)
    }
    
    public func `default`(logEntry: LogEntry) {
        log(level: .default, logEntry: logEntry)
    }
    
    public func error(logEntry: LogEntry) {
        log(level: .error, logEntry: logEntry)
    }
    
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
