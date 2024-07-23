//
//  TrendVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/23/24.
//

import Foundation

final class TrendVM: BaseVM {
    
    var inputImageNum: Observable<Int?> = Observable(User.shared.profileImageId)
    
    
    var outputImageNum: Observable<Int?> = Observable(nil)
    
    
    override func bind() {
        super.bind()
        
        inputImageNum.bind { [weak self] num in
            guard let self, let num else { return }
            outputImageNum.value = num
        }
    }
}
