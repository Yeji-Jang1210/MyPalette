//
//  Character.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

struct Character {
    private init(){}
    
    static var maxCount = 11
    static var list: [UIImage] {
        
        var list: [UIImage] = []
        
        for i in 0...maxCount {
            if let image = getImage(num: i){
                list.append(image)
            }
        }
        
        return list
    }

    static func getImage(num: Int) -> UIImage? {
        return UIImage(named: "profile_\(num)")
    }
}
