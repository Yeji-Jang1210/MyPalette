//
//  MBTICollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/28/24.
//

import UIKit
import SnapKit

final class MBTICollectionViewCell: UICollectionViewCell {
    
    lazy var mbtiView: CircleView = {
        let object = CircleView()
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mbtiView)
        mbtiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String){
        mbtiView.titleLabel.text = title
    }
}
