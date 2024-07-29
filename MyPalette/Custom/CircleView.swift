//
//  CircleButton.swift
//  MyPalette
//
//  Created by 장예지 on 7/28/24.
//

import UIKit
import SnapKit

final class CircleView: UIView {
    
    var titleLabel = {
        let object = UILabel()
        object.font = BaseFont.large.boldFont
        return object
    }()
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? Color.primaryBlue : .white
            titleLabel.textColor = isSelected ? .white : Color.warmGray
            layer.borderColor = isSelected ? Color.primaryBlue.cgColor : Color.warmGray.cgColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    //초기화 과정에서 didSet과 willSet은 실행되지 않음
    //따라서 별도의 메서드에서 isSelected를 실행한 것이다.
    private func setup() {
           layer.borderWidth = 1
           
           addSubview(titleLabel)
           titleLabel.snp.makeConstraints { make in
               make.center.equalToSuperview()
           }

           isSelected = false
       }
}
