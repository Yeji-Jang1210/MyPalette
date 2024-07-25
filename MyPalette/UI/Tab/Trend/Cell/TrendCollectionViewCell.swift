//
//  TrendCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import UIKit
import SnapKit
import Kingfisher

final class TrendCollectionViewCell: PhotoCollectionViewCell {
    
    private var likedView = LikedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubview(likedView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        likedView.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(12)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        cornerRadius = 20
    }
    
    public func setData(_ photo: Photo){
        if let url = URL(string: photo.urls.raw) {
            let processor = DownsamplingImageProcessor(size: imageView.frame.size)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: [.transition(.fade(1)), .forceTransition, .processor(processor)], completionHandler: nil)
            likedView.count = photo.likes
        }
    }
}
