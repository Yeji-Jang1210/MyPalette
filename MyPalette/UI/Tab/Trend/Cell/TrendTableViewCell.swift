//
//  TrendTableViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/23/24.
//

import UIKit
import SnapKit

final class TrendTableViewCell: UITableViewCell {
    
    private let trendTypeLabel = {
        let object = UILabel()
        object.font = BaseFont.large.boldFont
        return object
    }()
    
    lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return object
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        contentView.addSubview(trendTypeLabel)
        contentView.addSubview(collectionView)
    }
    
    func configureLayout(){
        trendTypeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(trendTypeLabel.snp.bottom).offset(12)
        }
    }
    
    public func setTitle(_ title: String){
        trendTypeLabel.text = title
    }
}
