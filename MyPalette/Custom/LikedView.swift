//
//  LikedView.swift
//  MyPalette
//
//  Created by 장예지 on 7/23/24.
//

import UIKit
import SnapKit

final class LikedView: UIView {
    
    private let starImageView = {
        let object = UIImageView()
        object.image = ImageAssets.star
        object.contentMode = .scaleAspectFit
        object.tintColor = .systemYellow
        return object
    }()
    
    private let likedLabel = {
        let object = UILabel()
        object.textColor = .white
        object.text = "88,888"
        object.font = BaseFont.small.basicFont
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.darkGray
        clipsToBounds = true
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(){
        addSubview(starImageView)
        addSubview(likedLabel)
    }
    
    private func configureLayout(){
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        likedLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        layer.cornerRadius = frame.height / 2
    }
}
