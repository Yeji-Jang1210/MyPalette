//
//  ProfileSettingVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
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

final class ProfileSettingVM: BaseVM {
    //MARK: - Input
    var inputNickname = Observable<String?>(User.shared.nickname)
    var inputImageNum = Observable<Int?>(User.shared.profileImageId)
    var inputUpdateTrigger: Observable<Void?> = Observable(nil)
    var inputSaveTrigger: Observable<Void?> = Observable(nil)
    
    //MARK: - Output
    var outputNickname = Observable<String?>(nil)
    var outputNicknameStatus = Observable<(ValidateNicknameStatus?, Bool?)>((nil, nil))
    var outputIsNicknameValid = Observable<Bool>(false)
    var outputImageNum = Observable<Int>(0)
    var outputIsUpdate = Observable<Bool?>(nil)
    var outputIsSaved = Observable<Bool?>(nil)
    
    override func bind(){
        inputNickname.bind { [weak self] nickname in
            guard let self else { return }
            outputNickname.value = nickname
            
            validateNickname { [weak self] status, isValid in
                guard let self else { return }
                outputNicknameStatus.value = (status, isValid)
                outputIsNicknameValid.value = isValid
            }
        }
        
        inputImageNum.bind { [weak self] num in
            guard let self else { return }
            outputImageNum.value = num ?? Int.random(in: 0...Character.maxCount)
            
            
        }
        
        inputUpdateTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            updateData()
        }
        
        inputSaveTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            createData()
        }
    }
    
    func validateNickname(completion: @escaping ( ValidateNicknameStatus?, Bool) -> ()){
        guard let nickname = inputNickname.value else {
            completion(ValidateNicknameStatus.invalid_nickname, false)
            return
        }
        
        let specificCharacter = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        
        if nickname.count < 2 || nickname.count >= 10 {
            completion(ValidateNicknameStatus.invalid_range, false)
            return
        }
        
        if nickname.rangeOfCharacter(from: specificCharacter) != nil {
            completion(ValidateNicknameStatus.contains_specific_character, false)
            return
        }
        
        if nickname.rangeOfCharacter(from: numbers) != nil {
            completion(ValidateNicknameStatus.contains_number, false)
            return
        }
        
        completion(ValidateNicknameStatus.nickname_isValid, true)
        return
    }
    
    func updateData(){
        userDataSaved { result in
            self.outputIsSaved.value = result
        }
    }
    
    func createData(){
        userDataSaved { result in
            self.outputIsUpdate.value = true
        }
    }
    
    func userDataSaved(completion: @escaping (Bool) -> Void){
        guard let nickname = outputNickname.value else {
            completion(false)
            return
        }
        
        User.shared.signupDate = Date.now
        User.shared.nickname = nickname
        User.shared.profileImageId = outputImageNum.value
        completion(true)
    }
    
}
