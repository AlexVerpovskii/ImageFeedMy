//
//  Extension+Logger.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation
import Logging

enum LogEvent {
   case error
   case info
}

struct LogModel {
    var serviceName: String
    var message: String
    var systemError: String?
    var eventType: LogEvent
}

final class Log {
    
    static func createlog(log: LogModel) {
        switch log.eventType {
        case .error:
            let logger = Logger(label: log.serviceName)
            logger.error("\(log.message): \(String(describing: log.systemError))")
        case .info:
            let logger = Logger(label: log.serviceName)
            logger.info("\(log.message): \(String(describing: log.systemError))")
        }
    }
}


