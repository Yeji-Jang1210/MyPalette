//
//  LikeCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import UIKit
import SnapKit

final class LikeCollectionViewCell: PhotoCollectionViewCell {
    
    private let saveButton = {
        let object = UIButton()
        object.setImage(ImageAssets.saveButtonActive, for: .selected)
        object.setImage(ImageAssets.saveButtonInActive, for: .normal)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubview(saveButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        saveButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(12)
            make.size.equalTo(30)
        }
    }
    
    func setData(isSelected: Bool){
        saveButton.isSelected = isSelected
    }
}
