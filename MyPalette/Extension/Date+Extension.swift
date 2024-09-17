//
//  Date+Extension.swift
//  MyPalette
//
//  Created by 장예지 on 7/25/24.
//

import Foundation

extension Date {
    func convertDateToString(format: DateFormat) -> String {
        return format.formatter.string(from: self)
    }
}

extension String {
    func convertStringToDate(format: DateFormat) -> Date? {
        return format.formatter.date(from: self)
    }
}

enum DateFormat: String {
    case signup = "yyyy. MM. dd 가입"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
    case created = "yyyy.MM.dd 게시됨"
}

extension DateFormat {
    private static var cachedFormatters = NSCache<NSString, DateFormatter>()
    
    var formatter: DateFormatter {
        return Self.cachedFormatter(self.rawValue)
    }
    
    static func cachedFormatter(_ dateFormat: String) -> DateFormatter {
        let dateFormatKey = NSString(string: dateFormat)
        if let cachedFormatter = cachedFormatters.object(forKey: dateFormatKey) {
            return cachedFormatter
        }
        
        let dateFormatter = DateFormatter()
        print(">>>>생성됨<<<<<<")
        dateFormatter.dateFormat = dateFormat
        cachedFormatters.setObject(dateFormatter, forKey: dateFormatKey)
        return dateFormatter
    }
}
