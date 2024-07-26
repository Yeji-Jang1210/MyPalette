//
//  Cell+Extension.swift
//  MyPalette
//
//  Created by 장예지 on 7/23/24.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
