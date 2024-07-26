//
//  SearchPhotoCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import UIKit
import Kingfisher
import SnapKit

final class SearchPhotoCollectionViewCell: PhotoCollectionViewCell {
    
    private let likedView = LikedView()
    let saveButton = {
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
    
    func setData(photo: Photo, isSelected: Bool){
        if let url = URL(string: photo.urls.small) {
            let processor = DownsamplingImageProcessor(size: imageView.frame.size)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: [ .processor(processor)], completionHandler: nil)
            likedView.count = photo.likes
        }
        
        saveButton.isSelected = isSelected
        
    }
}
