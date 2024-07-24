//
//  TrendCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import UIKit
import SnapKit

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
    
    public func setData(){
        likedView.count = Int.random(in: 10000...88888)
    }
}
