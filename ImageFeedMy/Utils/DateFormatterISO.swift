//
//  dateFormatter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 15.07.2024.
//

import Foundation

final class DateFormatterISO {
    static func dateFormatter(dateFromString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: dateFromString)
    }
}
