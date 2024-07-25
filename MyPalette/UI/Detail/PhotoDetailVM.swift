//
//  PhotoDetailVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import Foundation

final class PhotoDetailVM: BaseVM {
    var inputPhoto: Observable<Photo?> = Observable(nil)
    var inputSetImageSuccessTrigger: Observable<Void?> = Observable(nil)
    var outputPhoto: Observable<Photo?> = Observable(nil)
    var outputSetPhotoImageTrigger: Observable<String?> = Observable(nil)
    var outputStatistics: Observable<PhotoStatistics?> = Observable(nil)
    
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
            DispatchQueue.global().async {
                self.fetchStatistics(id: photo.id)
            }
        }
        
        inputSetImageSuccessTrigger.bind { [weak self] trigger in
            guard let self, let trigger else { return }
            
            outputPhoto.value = photo
            outputStatistics.value = statistics
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
