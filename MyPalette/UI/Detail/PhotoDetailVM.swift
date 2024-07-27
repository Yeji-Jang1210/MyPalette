//
//  PhotoDetailVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import Foundation

final class PhotoDetailVM: BaseVM {
    var inputPhoto = Observable<Photo?>(nil)
    var inputSetImageSuccessTrigger = Observable<Void?>(nil)
    var inputSaveButtonTappedTrigger = Observable<Bool?> (nil)
    var inputViewWillAppearTrigger = Observable<Void?>(nil)
    var outputPhoto = Observable<Photo?>(nil)
    var outputSetPhotoImageTrigger = Observable<String?>(nil)
    var outputStatistics = Observable<PhotoStatistics?>(nil)
    var outputPhotoIsSaved = Observable<Bool?>(nil)
    var outputPresentToastMessage = Observable<String?>(nil)
    
    var photo: Photo?
    var statistics: PhotoStatistics?
    
    init(photo: Photo){
        self.inputPhoto.value = photo
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        inputPhoto.bind { [weak self] photo in
            guard let self, let photo else { return }
            
            self.photo = photo
            outputPhotoIsSaved.value = SavePhotoRepository.shared.findPhoto(photo.id)
            DispatchQueue.global().async {
                self.fetchStatistics(id: photo.id)
            }
        }
        
        inputSetImageSuccessTrigger.bind { [weak self] trigger in
            guard let self, let trigger else { return }
            
            outputPhoto.value = photo
            outputStatistics.value = statistics
        }
        
        inputSaveButtonTappedTrigger.bind { [weak self] isSelected in
            guard let self, let isSelected, let photo = photo else { return }
            
            if isSelected {
                photo.urls.raw.fetchImage { image in
                    guard let image else {
                        self.outputPresentToastMessage.value = SavePhotoStatus.error.message
                        return
                    }
                    FileManager.saveImageToDocument(image: image, filename: photo.id)
                    SavePhotoRepository.shared.savePhoto(photo)
                    self.outputPresentToastMessage.value = SavePhotoStatus.saved.message
                }
                
            } else {
                SavePhotoRepository.shared.deletePhoto(photo.id)
                outputPresentToastMessage.value = SavePhotoStatus.removed.message
            }
        }
        
        inputViewWillAppearTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil, let photo = photo else { return }
            
            outputPhotoIsSaved.value = SavePhotoRepository.shared.findPhoto(photo.id)
        }
    }
    
    private func fetchStatistics(id: String){
        APIService.shared.networking(api: .statistics(id: id), of: PhotoStatistics.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let result):
                statistics = result
                outputSetPhotoImageTrigger.value = photo?.urls.raw
            case .error(let error):
                print(error)
            }
        }
    }
}
