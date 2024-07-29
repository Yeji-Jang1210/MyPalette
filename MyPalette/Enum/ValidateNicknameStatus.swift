//
//  ValidateNicknameStatus.swift
//  MyPalette
//
//  Created by 장예지 on 7/29/24.
//

import Foundation

enum ValidateNicknameStatus {
    case invalid_nickname
    case invalid_range
    case contains_specific_character
    case contains_number
    case nickname_isValid
    
    var message: String {
        switch self {
        case .invalid_nickname:
            return ""
        case .invalid_range:
            return Localized.nickname_range_error.text
        case .contains_specific_character:
            return Localized.nickname_contains_specific_character.text
        case .contains_number:
            return Localized.nickname_contains_number.text
        case .nickname_isValid:
            return Localized.nickname_isValid.text
        }
    }
}
