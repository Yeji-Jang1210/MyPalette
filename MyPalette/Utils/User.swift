//
//  User.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import Foundation



class User {
    static var shared = User()
    
    private init(){}
    
    var nickname: String {
        get {
            return UserDefaults.standard.string(forKey: "nickname") ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "nickname")
        }
    }
    
    var signupDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "signupDate") as? Date
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "signupDate")
        }
    }
    
    var profileImageId: Int? {
        get {
            return UserDefaults.standard.object(forKey: "profileImageId") as? Int
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "profileImageId")
        }
    }
    
    var signupDateText: String {
        guard let date = signupDate else { return "" }
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd"
        return "\(format.string(from: date)) 가입"
    }
    
    func delete(){
        nickname = ""
        profileImageId = nil
        signupDate = nil
        
        
        print(User.shared.nickname)
        print(User.shared.profileImageId)
        print(User.shared.signupDateText)
    }
}
