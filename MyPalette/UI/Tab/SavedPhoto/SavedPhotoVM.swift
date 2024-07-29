//
//  SavedPhotoVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/26/24.
//

import Foundation
import RealmSwift

enum SavedOrderType {
    case latest
    case oldest
    
    var text: String {
        switch self {
        case .latest:
            Localized.latest.text
        case .oldest:
            Localized.oldest.text
        }
    }
}

final class SavedPhotoVM: BaseVM {
    
    var inputSaveButtonTapped: Observable<Int?> = Observable(nil)
    var inputTappedPhoto: Observable<Int?> = Observable(nil)
    var inputOrderedPhoto: Observable<SavedOrderType?> = Observable(nil)
    var inputOrderButtonTapped = Observable<Bool?>(nil)
    
    var outputSavedPhotoList: Observable<Results<SavedPhoto>?> = Observable(nil)
    var outputPresentToast: Observable<Void?> = Observable(nil)
    var outputPhoto: Observable<Photo?> = Observable(nil)
    var outputOrderButtonSelected = Observable<Bool?>(nil)
    
    override func bind() {
        super.bind()
        
        inputOrderedPhoto.bind { [weak self] order in
            guard let self, let order else { return }
            outputSavedPhotoList.value = SavePhotoRepository.shared.sortSavedPhotos(order)
            outputOrderButtonSelected.value = order == .latest ? false : true
        }
        
        inputSaveButtonTapped.bind { [weak self] index in
            guard let self, let index, let id = outputSavedPhotoList.value?[index].photoId else { return }
            
            SavePhotoRepository.shared.deletePhoto(id)
            
            if let order = inputOrderedPhoto.value {
                outputSavedPhotoList.value = SavePhotoRepository.shared.sortSavedPhotos(order)
            }
            
            outputPresentToast.value = ()
        }
        
        inputTappedPhoto.bind { [weak self] index in
            guard let self, let index, let photo = outputSavedPhotoList.value?[index] else { return }
            
            outputPhoto.value = photo.convertSavedPhotoToPhoto()
        }
        
        inputOrderButtonTapped.bind { [weak self] isTapped in
            guard let self, let isTapped, let isEmpty = outputSavedPhotoList.value?.isEmpty else { return }
            if !isEmpty{
                inputOrderedPhoto.value = isTapped ? .oldest : .latest
            }
        }
    }
    
    
}
