//
//  SearchPhotoCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import UIKit
import SnapKit

final class SearchPhotoCollectionViewCell: PhotoCollectionViewCell {
    
    private let likedView = LikedView()
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
        addSubview(likedView)
        addSubview(saveButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        likedView.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(12)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(likedView)
            make.size.equalTo(30)
        }
    }
    
    func setData(isSelected: Bool){
        likedView.count = Int.random(in: 10000...88888)
        saveButton.isSelected = isSelected
    }
}
