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
        let subsystem = Bundle.main.bundleIdentifier ?? "kz.bolistik.test"
        logger = Logger(subsystem: subsystem, category: category)
    }

    func debug(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .debug, metadata: metadata)
    }

    func info(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .info, metadata: metadata)
    }

    func error(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .error, metadata: metadata)
    }

    func fault(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .fault, metadata: metadata)
    }

    private func log(_ message: String, level: OSLogType, metadata: [String: String]? = nil) {
        if let metadata = metadata {
            let data = metadata.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            logger.log(level: level, "[\(category)]: \(message) -> \(data, privacy: .public)")
        } else {
            logger.log(level: level, "[\(category)]: \(message)")
        }
    }
}
