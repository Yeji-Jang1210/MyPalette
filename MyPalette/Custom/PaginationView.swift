//
//  PaginationView.swift
//  MyPalette
//
//  Created by 장예지 on 7/30/24.
//

import UIKit
import SnapKit

final class PaginationView: UIView {
    
    private lazy var pageLabel = {
        let object = UILabel()
        object.font = BaseFont.medium.basicFont
        object.textColor = .white
        return object
    }()
    
    var page: Int = 0 {
        didSet {
            pageLabel.text = "\(page+1) / \(totalPage)"
        }
    }
    
    var totalPage: Int = 0
    
    init(){
        super.init(frame: .zero)
        
        backgroundColor = Color.darkGray
        clipsToBounds = true
        
        addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
