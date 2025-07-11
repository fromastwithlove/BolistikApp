//
//  AppLogger.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 22.12.24.
//

import Foundation
import os

struct AppLogger {
    
    private let logger: Logger
    private let category: String
    
    init(category: String) {
        self.category = category
        if let subsystem = Bundle.main.bundleIdentifier {
            logger = Logger(subsystem: subsystem, category: category)
        } else {
            logger = Logger()
        }
    }

    // MARK: - Public Methods
    
    func debug<T: Encodable>(_ message: String, metadata: T? = Optional<Data>.none) {
        log(message, level: .debug, metadata: metadata)
    }

    func info<T: Encodable>(_ message: String, metadata: T? = Optional<Data>.none) {
        log(message, level: .info, metadata: metadata)
    }

    func error<T: Encodable>(_ message: String, metadata: T? = Optional<Data>.none) {
        log(message, level: .error, metadata: metadata)
    }

    func fault<T: Encodable>(_ message: String, metadata: T? = Optional<Data>.none) {
        log(message, level: .fault, metadata: metadata)
    }
    
    // MARK: - Private Methods
    
    private func log<T: Encodable>(_ message: String, level: OSLogType, metadata: T? = nil) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let baseLogMessage = "[\(timestamp)] [\(category)]: \(message)"
        
        let fullMessage: String
        if let metadata = metadata, let json = encodeToJSONString(metadata) {
            fullMessage = "\(baseLogMessage)\nMetadata:\n\(json)"
        } else {
            fullMessage = baseLogMessage
        }
        
        logger.log(level: level, "\(fullMessage)")
    }
    
    private func encodeToJSONString<T: Encodable>(_ value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        guard let data = try? encoder.encode(value) else { return nil }
        return String(data: data, encoding: .utf8)
    }

}
