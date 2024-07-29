//
//  User.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import Foundation

struct UserDefaultsManager {
    enum Keys: String, CaseIterable {
        case nickname
        case signupDate
        case profileImageId
        case mbti
    }
    
    static func set<T>(to: T, forKey: Self.Keys) {
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
        print("📁 UserDefaultsManager: save \(forKey) complete")
    }
    
    static func get(forKey: Self.Keys) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
    
    static var signupDateText: String {
        guard let date = UserDefaultsManager.get(forKey: .signupDate) as? Date else { return "" }
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd"
        return "\(format.string(from: date)) 가입"
    }
    
    static func delete(){
        for key in Keys.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        
        // 데이터 삭제 확인
        checkUserDefaults()
    }
    
    static func createUser(nickname: String, mbti: [Int], profileImage: Int){
        UserDefaultsManager.set(to: nickname, forKey: .nickname)
        UserDefaultsManager.set(to: mbti, forKey: .mbti)
        UserDefaultsManager.set(to: Date(), forKey: .signupDate)
        UserDefaultsManager.set(to: profileImage, forKey: .profileImageId)
    }
    
    static func updateUser(nickname: String, mbti: [Int], profileImage: Int){
        UserDefaultsManager.set(to: nickname, forKey: .nickname)
        UserDefaultsManager.set(to: mbti, forKey: .mbti)
        UserDefaultsManager.set(to: profileImage, forKey: .profileImageId)
    }
    
    static func checkUserDefaults(){
        let nickname = UserDefaults.standard.object(forKey: "nickname")
        let signupDate = UserDefaults.standard.object(forKey: "signupDate")
        let profileImageId = UserDefaults.standard.object(forKey: "profileImageId")
        let mbti = UserDefaults.standard.object(forKey: "mbti") as? [Int]

        print("👤 nickname: \(nickname ?? "")")
        print("📆 signupDate: \(signupDate ?? "")")
        print("🥹 profileImageId: \(profileImageId ?? "")")
        print("🍀 mbti: \(mbti ?? [])")
    }
}
