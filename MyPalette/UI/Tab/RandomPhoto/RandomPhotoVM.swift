//
//  RandomPhotoVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/30/24.
//

import Foundation

final class RandomPhotoVM: BaseVM {
    var outputRandomPhoto = Observable<[Photo]?>(nil)
    var outputPageNumber = Observable<Int?>(nil)
    var outputTotalPageNumber = Observable<Int?>(nil)
    
    var inputRandomPhoto = Observable<[Photo]>([])
    override func bind() {
        super.bind()
        
        inputRandomPhoto.bind { [weak self] photos in
            guard let self else { return }
            
            APIService.shared.networking(api: .random, of: [Photo].self) { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let results):
                    outputRandomPhoto.value = results
                    outputTotalPageNumber.value = results.count
                case .error(let error):
                    print(error)
                }
            }
        }
        
    }
}
