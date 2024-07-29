//
//  MBTI.swift
//  MyPalette
//
//  Created by 장예지 on 7/28/24.
//

import Foundation

enum MBTI: Int, CaseIterable {
    case E
    case I
    case S
    case N
    case T
    case F
    case J
    case P
    
    var title: String {
        switch self {
        case .E:
            return "E"
        case .I:
            return "I"
        case .S:
            return "S"
        case .N:
            return "N"
        case .T:
            return "T"
        case .F:
            return "F"
        case .J:
            return "J"
        case .P:
            return "P"
        }
    }
}
