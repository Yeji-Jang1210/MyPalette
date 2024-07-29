//
//  PhotoDetailVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import Foundation
import UIKit

final class PhotoDetailVM: BaseVM {
    var inputPhoto = Observable<Photo?>(nil)
    var inputSaveButtonTappedTrigger = Observable<Bool?> (nil)
    var inputViewWillAppearTrigger = Observable<Void?>(nil)
    
    var outputPhoto = Observable<Photo?>(nil)
    var outputSetPhotoImageTrigger = Observable<String?>(nil)
    var outputStatistics = Observable<PhotoStatistics?>(nil)
    var outputPhotoIsSaved = Observable<Bool?>(nil)
    var outputPresentToastMessage = Observable<String?>(nil)
    
    init(photo: Photo){
        self.inputPhoto.value = photo
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        inputPhoto.bind { [weak self] photo in
            guard let self, let photo else { return }
            
            outputSetPhotoImageTrigger.value = photo.urls.raw
            outputPhoto.value = photo
            outputPhotoIsSaved.value = SavePhotoRepository.shared.findPhoto(photo.id)
            DispatchQueue.global().async {
                self.fetchStatistics(id: photo.id)
            }
        }
        
        
        inputSaveButtonTappedTrigger.bind { [weak self] isSelected in
            guard let self, let isSelected, let photo = outputPhoto.value else { return }
            
            if isSelected {
                let group = DispatchGroup()
                
                var mainPhoto: UIImage?
                var profilePhoto: UIImage?
                
                group.enter()
                photo.urls.raw.fetchImage { image in
                    mainPhoto = image
                    group.leave()
                }
                
                group.enter()
                photo.user.profileImage.medium.fetchImage { image in
                    profilePhoto = image
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    guard let mainPhoto, let profilePhoto else {
                        self.outputPresentToastMessage.value = SavePhotoStatus.error.message
                        return
                    }
                    
                    FileManager.saveImageToDocument(image: mainPhoto, filename: photo.id)
                    FileManager.saveImageToDocument(image: profilePhoto, filename: photo.userProfileImageName)
                    SavePhotoRepository.shared.savePhoto(photo)
                    self.outputPresentToastMessage.value = SavePhotoStatus.saved.message
                }
                
            } else {
                SavePhotoRepository.shared.deletePhoto(photo.id)
                outputPresentToastMessage.value = SavePhotoStatus.removed.message
            }
        }
        
        inputViewWillAppearTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil, let photo = outputPhoto.value else { return }
            
            outputPhotoIsSaved.value = SavePhotoRepository.shared.findPhoto(photo.id)
        }
    }
    
    private func fetchStatistics(id: String){
        APIService.shared.networking(api: .statistics(id: id), of: PhotoStatistics.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let result):
                outputStatistics.value = result
            case .error(let error):
                print(error)
                outputSetPhotoImageTrigger.value = nil
                outputPresentToastMessage.value = "네트워크 연결에 실패했습니다."
            }
        }
    }
}
