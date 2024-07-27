//
//  MBTICollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/28/24.
//

import UIKit
import SnapKit

final class MBTICollectionViewCell: UICollectionViewCell {
    
    lazy var mbtiButton: CircleButton = {
        let object = CircleButton()
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mbtiButton)
        mbtiButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String){
        mbtiButton.setTitle(title, for: .normal)
    }
}
