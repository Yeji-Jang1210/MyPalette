//
//  BaseFont.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

enum BaseFont: CGFloat {
    case small = 10
    case medium = 12
    case mediumLarge = 14
    case large = 16
    case nickname = 20
    
    var basicFont: UIFont {
        return UIFont.systemFont(ofSize: self.rawValue)
    }
    
    var boldFont: UIFont {
        return UIFont.boldSystemFont(ofSize: self.rawValue)
    }
    
}
