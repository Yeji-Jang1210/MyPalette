//
//  TrendVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/23/24.
//

import Foundation
import Alamofire

final class TrendVM: BaseVM {
    
    var inputProfileImageNum: Observable<Int?> = Observable(UserDefaultsManager.get(forKey: .profileImageId) as? Int)
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputProfileEditSucceed: Observable<Void?> = Observable(nil)
    
    var outputProfileImageNum: Observable<Int?> = Observable(nil)
    var outputPhotoList: Observable<[[Photo]]> = Observable(Array(repeating: [], count: Topics.allCases.count))
    var outputError: Observable<AFError?> = Observable(nil)
    
    override func bind() {
        super.bind()
        
        inputViewWillAppearTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            fetchData()
        }
        
        inputProfileImageNum.bind { [weak self] num in
            guard let self, let num else { return }
            outputProfileImageNum.value = num
        }
        
        inputProfileEditSucceed.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            outputProfileImageNum.value = UserDefaultsManager.get(forKey: .profileImageId) as? Int
        }
    }
    
    private func fetchData(){
        let group = DispatchGroup()
        var topicsImage: [[Photo]] = Array(repeating: [], count: Topics.allCases.count)
        
        for topic in Topics.allCases {
            group.enter()
            DispatchQueue.global().async {
                APIService.shared.networking(api: .topic(id: topic.slug), of: [Photo].self) { [weak self] response in
                    switch response {
                    case .success(let value):
                        topicsImage[topic.rawValue] = value
                        group.leave()
                    case .error(let error):
                        DispatchQueue.main.async{
                            self?.outputError.value = error
                        }
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            self.outputPhotoList.value = topicsImage
        }
        
    }
}
