//
//  Logger.swift
//  ClashParty
//
//  Logging utility for the application
//

import Foundation
import os.log

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

class Logger {
    static let shared = Logger()
    
    private let osLog = OSLog(subsystem: "party.mihomo.app", category: "ClashParty")
    private var logMessages: [String] = []
    private let maxLogMessages = 1000
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
    
    private func log(_ message: String, level: LogLevel, file: String, function: String, line: Int) {
        let timestamp = dateFormatter.string(from: Date())
        let filename = (file as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.rawValue)] [\(filename):\(line)] \(function) - \(message)"
        
        // Log to system
        let type: OSLogType
        switch level {
        case .debug:
            type = .debug
        case .info:
            type = .info
        case .warning:
            type = .default
        case .error:
            type = .error
        }
        
        os_log("%{public}@", log: osLog, type: type, logMessage)
        
        // Store in memory
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.logMessages.append(logMessage)
            if self.logMessages.count > self.maxLogMessages {
                self.logMessages.removeFirst(self.logMessages.count - self.maxLogMessages)
            }
        }
        
        // Also print to console in debug builds
        #if DEBUG
        print(logMessage)
        #endif
    }
    
    func getRecentLogs(count: Int = 100) -> [String] {
        return Array(logMessages.suffix(count))
    }
    
    func clearLogs() {
        logMessages.removeAll()
    }
    
    func exportLogs() -> String {
        return logMessages.joined(separator: "\n")
    }
    
    func saveLogs(to url: URL) throws {
        let content = exportLogs()
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
}
