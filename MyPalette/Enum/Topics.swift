//
//  Topics.swift
//  MyPalette
//
//  Created by 장예지 on 7/27/24.
//

import Foundation

enum Topics: Int, CaseIterable {
    case goldenHour
    case businessAndWork
    case architectureAndInterior
    
    var slug: String {
        switch self {
        case .goldenHour:
            return "golden-hour"
        case .businessAndWork:
            return "business-work"
        case .architectureAndInterior:
            return "architecture-interior"
        }
    }
    
    var title: String {
        switch self {
        case .goldenHour:
            return Localized.goldenHour.title
        case .businessAndWork:
            return Localized.businessAndWork.title
        case .architectureAndInterior:
            return Localized.architectureAndInterior.title
        }
    }
}
