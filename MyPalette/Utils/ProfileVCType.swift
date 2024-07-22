//
//  ProfileVCType.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import Foundation

enum ProfileVCType: Int {
    case setting
    case edit
    
    var navTitle: String {
        switch self {
        case .setting:
            return Localized.profile_setting.title
        case .edit:
            return Localized.profile_edit.title
        }
    }
}
