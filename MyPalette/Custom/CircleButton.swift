//
//  CircleButton.swift
//  MyPalette
//
//  Created by 장예지 on 7/28/24.
//

import UIKit
import SnapKit

final class CircleButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? Color.primaryBlue : .white
            setTitleColor(isSelected ? .white : Color.warmGray, for: .normal)
            layer.borderColor = isSelected ? Color.primaryBlue.cgColor : Color.warmGray.cgColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        layer.borderWidth = 1
        isSelected = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
