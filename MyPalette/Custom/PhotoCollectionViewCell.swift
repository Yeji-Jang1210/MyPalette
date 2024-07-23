//
//  TrendCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/23/24.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    private let imageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        object.backgroundColor = .red
        return object
    }()
    
    private let likedView = {
        let object = LikedView()
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        contentView.addSubview(imageView)
        contentView.addSubview(likedView)
    }
    
    func configureLayout(){
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        likedView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.bottom.equalTo(imageView).inset(12)
        }
    }
    
    public func setData(isTopic: Bool){
        imageView.layer.cornerRadius = isTopic ? 20 : 0
    }
}
