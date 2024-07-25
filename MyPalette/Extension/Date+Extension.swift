//
//  Date+Extension.swift
//  MyPalette
//
//  Created by 장예지 on 7/25/24.
//

import Foundation

extension Date {
    func convertDateToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func convertStringToDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
