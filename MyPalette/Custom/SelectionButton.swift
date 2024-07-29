//
//  SelectionButton.swift
//  MyPalette
//
//  Created by 장예지 on 7/26/24.
//

import UIKit
import SnapKit

final class SelectionButton: UIButton {
    var selectTitle: String
    var unselectTitle: String
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .black : .white
            tintColor = isSelected ? .white : .black
            setTitleColor(isSelected ? .white : .black, for: .normal)
            setTitle(isSelected ? selectTitle : unselectTitle, for: .normal)
        }
    }
    
    init(selectTitle: String, unselectTitle: String){
        self.selectTitle = selectTitle
        self.unselectTitle = unselectTitle
        super.init(frame: .zero)
        isSelected = false
        configureLayout()
        configureUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func configureLayout(){
        snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(100)
        }
    }
    
    private func configureUI(){
        setImage(ImageAssets.sort, for: .normal)
        titleLabel?.font = BaseFont.medium.boldFont
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
