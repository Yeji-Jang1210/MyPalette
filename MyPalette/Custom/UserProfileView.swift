//
//  UserProfileView.swift
//  MyPalette
//
//  Created by 장예지 on 7/25/24.
//

import UIKit
import Kingfisher
import SnapKit

final class UserProfileView: UIView {
    private let profileImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        return object
    }()
    
    private let stackView = {
        let object = UIStackView()
        object.axis = .vertical
        object.spacing = 4
        return object
    }()
    
    private let userNameLabel = {
        let object = UILabel()
        object.font = BaseFont.mediumLarge.basicFont
        return object
    }()
    
    private let updateDateLabel = {
        let object = UILabel()
        object.font = BaseFont.medium.boldFont
        return object
    }()
    
    let saveButton = {
        let object = UIButton()
        object.setImage(ImageAssets.likeButtonInActive, for: .normal)
        object.setImage(ImageAssets.likeButton, for: .selected)
        return object
    }()
    
    var image: UIImage? = nil {
        didSet {
            profileImageView.image = image
        }
    }
    
    var imagePath: String = "" {
        didSet {
            guard let url = URL(string: imagePath) else { return }
            profileImageView.kf.setImage(with: url)
        }
    }
    
    var userName: String = "" {
        didSet {
            userNameLabel.text = userName
        }
    }
    
    var updateDate: String? {
        didSet {
            updateDateLabel.text = updateDate
        }
    }
    
    var textColor: UIColor = .black {
        didSet {
            userNameLabel.textColor = textColor
            updateDateLabel.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(){
        addSubview(profileImageView)
        
        addSubview(stackView)
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(updateDateLabel)
        
        addSubview(saveButton)
    }
    
    private func configureLayout(){
        snp.makeConstraints { make in
            make.height.equalTo(66)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
    }
}
