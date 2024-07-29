//
//  BaseButtonStyle.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

enum BaseButtonStyle {
    case primary
    case select
    case unselect
    
    var backColor: UIColor {
        switch self {
        case .primary:
            return Color.primaryBlue
        case .select:
            return Color.darkGray
        case .unselect:
            return Color.white
        }
    }
    
    var fontColor: UIColor {
        switch self {
        case .primary, .select:
            return Color.white
        case .unselect:
            return Color.black
        }
    }
    
    var font: UIFont {
        switch self {
        case .primary:
            return UIFont.systemFont(ofSize: 15, weight: .heavy)
        default:
            return BaseFont.small.basicFont
        }
    }
    
    var height: CGFloat {
        switch self {
        case .primary:
            return 44
        case .select, .unselect:
            return 16
        }
    }
}

