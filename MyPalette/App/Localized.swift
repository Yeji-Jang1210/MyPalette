//
//  Localized.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import Foundation

enum Localized {
    //onboarding
    case start
    
    //tabBar
    case trend
    case randomPhoto
    case searchPhoto
    case like
    
    //profile
    case profile_setting
    case profile_edit
    case nickname_placeholder
    case user_info_saved_error
    
    //nickname Error
    case nickname_range_error
    case nickname_contains_specific_character
    case nickname_contains_number
    case nickname_isValid
    
    //etc
    case complete
    case save_button
    case searchBar_placeholder
    case search_result_init
    case search_result_empty
    
    //topic
    case goldenHour
    case businessAndWork
    case architectureAndInterior
    
    //detail
    case info
    case size
    case views
    case downloads
    
    var title: String {
        switch self {
        case .start:
            return "시작하기"
        case .trend:
            return "OUR TOPIC"
        case .randomPhoto:
            return ""
        case .searchPhoto:
            return "SEARCH PHOTO"
        case .like:
            return "MY POLAROID"
        case .profile_setting:
            return "PROFILE SETTING"
        case .profile_edit:
            return "EDIT PROFILE"
        case .save_button:
            return "저장"
        case .goldenHour:
            return "골든 아워"
        case .businessAndWork:
            return "비즈니스 및 업무"
        case .architectureAndInterior:
            return "건축 및 인테리어"
        case .size:
            return "크기"
        case .views:
            return "조회수"
        case .downloads:
            return "다운로드"
        default:
            return ""
        }
    }
    
    var text: String {
        switch self {
        case .user_info_saved_error:
            return "저장에 실패했습니다."
        case .nickname_placeholder:
            return "닉네임을 입력해 주세요:)"
        case .nickname_range_error:
            return "2글자 이상 10글자 미만으로 입력해주세요"
        case .nickname_contains_specific_character:
            return "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .nickname_contains_number:
            return "닉네임에 숫자는 포함할 수 없어요"
        case .nickname_isValid:
            return "사용가능한 닉네임입니다."
        case .complete:
            return "완료"
        case .searchBar_placeholder:
            return "키워드 검색"
        case .search_result_init:
            return "사진을 검색해보세요."
        case .search_result_empty:
            return "검색 결과가 없어요."
        case .info:
            return "정보"
        default:
            return ""
        }
    }
    
    var message: String {
        return ""
    }
    
    var confirm: String {
        return ""
    }
    
    var cancel: String {
        return ""
    }
}
