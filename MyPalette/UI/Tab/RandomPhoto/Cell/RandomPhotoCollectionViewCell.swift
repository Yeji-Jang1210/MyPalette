//
//  RandomPhotoCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/30/24.
//

import UIKit
import SnapKit
import Kingfisher

final class RandomPhotoCollectionViewCell: UICollectionViewCell {
    
    let profileView = {
        let object = UserProfileView()
        object.textColor = .white
        return object
    }()
    
    let imageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(profileView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        profileView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(_ photo: Photo){
        profileView.imagePath = photo.user.profileImage.medium
        profileView.userName = photo.user.name
        profileView.updateDate = photo.createdDateText
        if let url = URL(string: photo.urls.raw) {
            let processor = DownsamplingImageProcessor(size: imageView.frame.size)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: [.transition(.fade(1)), .forceTransition, .processor(processor)], completionHandler: nil)
        }
    }
}
