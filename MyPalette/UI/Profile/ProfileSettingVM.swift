//
//  ProfileSettingVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import Foundation
import RealmSwift

final class ProfileSettingVM: BaseVM {
    //MARK: - Input
    var inputNickname = Observable<String?>(UserDefaultsManager.get(forKey: .nickname) as? String)
    var inputImageNum = Observable<Int?>(UserDefaultsManager.get(forKey: .profileImageId) as? Int)
    var inputMBTI = Observable<[Int]?>(UserDefaultsManager.get(forKey: .mbti) as? [Int])
    var inputUpdateTrigger = Observable<Void?>(nil)
    var inputSaveTrigger = Observable<Void?>(nil)
    var inputDeleteUserTrigger = Observable<Void?>(nil)
    var inputMBTIButtonTapped = Observable<Int?>(nil)
    
    //MARK: - Output
    var outputNickname = Observable<String?>(nil)
    var outputNicknameStatus = Observable<(ValidateNicknameStatus?, Bool?)>((nil, nil))
    var outputIsVerifiedProfile = Observable<Bool>(false)
    var outputImageNum = Observable<Int>(0)
    var outputIsUpdate = Observable<Bool?>(nil)
    var outputIsSaved = Observable<Bool?>(nil)
    var outputIsDeleteSucceeded = Observable<Bool?>(nil)
    var outputMBTIButton = Observable<[Int: Bool]>([:])
    
    private var isVerifiedNickname: Bool = false  {
        didSet {
            outputIsVerifiedProfile.value = isVerifiedMBTI && isVerifiedNickname
        }
    }
    
    private var isVerifiedMBTI: Bool = false {
        didSet {
            outputIsVerifiedProfile.value = isVerifiedMBTI && isVerifiedNickname
        }
    }
    
    private var mbti: [Int: Bool] = [:]
    
    override init(){
        for preference in MBTI.allCases {
            mbti[preference.rawValue] = false
            outputMBTIButton.value = mbti
        }
    }
    
    override func bind(){
        inputNickname.bind { [weak self] nickname in
            guard let self else { return }
            outputNickname.value = nickname
            
            validateNickname { [weak self] status, isValid in
                guard let self else { return }
                outputNicknameStatus.value = (status, isValid)
                isVerifiedNickname = isValid
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
        
        inputDeleteUserTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            
            deletePhotos()
            UserDefaultsManager.delete()
            SavePhotoRepository.shared.deleteAll { [weak self] result in
                guard let self else { return }
                outputIsDeleteSucceeded.value = result
            }
        }
        
        inputMBTI.bind { [weak self] userMBTI in
            guard let self, let userMBTI else { return }
            for selected in userMBTI {
                mbti[selected] = true
            }
            isVerifiedMBTI = true
            outputMBTIButton.value = mbti
        }
        
        inputMBTIButtonTapped.bind { [weak self] index in
            guard let self, let index else { return }
            
            if let isSelected = mbti[index] {
                if isSelected {
                    mbti[index]?.toggle()
                } else {
                    let oppositeIndex = (index % 2 == 0) ? index + 1 : index - 1
                    mbti[oppositeIndex] = false
                    mbti[index]?.toggle()
                }
                
                let selectedCount = mbti.values.filter({ $0 == true }).count
                isVerifiedMBTI = selectedCount == 4
                outputMBTIButton.value = mbti
            }
        }
    }
    
    private func validateNickname(completion: @escaping ( ValidateNicknameStatus?, Bool) -> ()){
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
    
    private func updateData(){
        guard let nickname = inputNickname.value else { return }
        
        UserDefaultsManager.updateUser(nickname: nickname, mbti: createMBTI(), profileImage: outputImageNum.value)
        self.outputIsSaved.value = true
    }
    
    private func createData(){
        guard let nickname = inputNickname.value else { return }
        UserDefaultsManager.createUser(nickname: nickname, mbti: createMBTI(), profileImage: outputImageNum.value)
        self.outputIsUpdate.value = true
    }
    
    private func deletePhotos(){
        let photos = SavePhotoRepository.shared.fetchPhotos()
        for photo in photos {
            FileManager.removeImageFromDocument(filename: photo.photoId)
            FileManager.removeImageFromDocument(filename: photo.userProfileImageName)
        }
    }
    
    private func createMBTI() -> [Int]{
        let mbti = mbti
            .filter{ $0.value == true }
            .map { $0.key }
            .sorted(by:<)
        
        return mbti
    }
}
