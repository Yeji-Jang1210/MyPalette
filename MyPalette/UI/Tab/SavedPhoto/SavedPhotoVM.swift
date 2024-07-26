//
//  SavedPhotoVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/26/24.
//

import Foundation
import RealmSwift

final class SavedPhotoVM: BaseVM {
    
    var inputViewAppearTrigger: Observable<Void?> = Observable(nil)
    var inputSaveButtonTapped: Observable<Int?> = Observable(nil)
    var inputTappedPhoto: Observable<Int?> = Observable(nil)
    
    var outputSavedPhotoList: Observable<Results<SavedPhoto>?> = Observable(nil)
    var outputPresentToast: Observable<Void?> = Observable(nil)
    var outputPhoto: Observable<Photo?> = Observable(nil)
    
    override func bind() {
        super.bind()
        
        inputViewAppearTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            
            outputSavedPhotoList.value = SavePhotoRepository.shared.fetchPhotos()
        }
        
        inputSaveButtonTapped.bind { [weak self] index in
            guard let self, let index, let id = outputSavedPhotoList.value?[index].photoId else { return }
            
            SavePhotoRepository.shared.deletePhoto(id)
            outputSavedPhotoList.value = SavePhotoRepository.shared.fetchPhotos()
            outputPresentToast.value = ()
        }
        
        inputTappedPhoto.bind { [weak self] index in
            guard let self, let index, let id = outputSavedPhotoList.value?[index].photoId else { return }
            
            DispatchQueue.global().async {
                APIService.shared.networking(api: .getPhoto(id: id), of: Photo.self) { [weak self] response in
                    guard let self else { return }
                    switch response {
                    case .success(let photo):
                        DispatchQueue.main.async {
                            self.outputPhoto.value = photo
                        }
                    case .error(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    
}
