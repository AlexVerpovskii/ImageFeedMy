//
//  Extension+Logger.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

//TODO: Доработать в след спринте.
enum LogEvent: String {
   case e = "[‼️]" // error
   case i = "[ℹ️]" // info
   case d = "[💬]" // debug
   case v = "[🔬]" // verbose
   case w = "[⚠️]" // warning
   case s = "[🔥]" // severe
}

class Log {
    
   static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS" // Use your own
   static var dateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = dateFormat
      formatter.locale = Locale.current
      formatter.timeZone = TimeZone.current
      return formatter
    }
}
