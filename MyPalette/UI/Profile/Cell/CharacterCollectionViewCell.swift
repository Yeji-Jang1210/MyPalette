//
//  CharacterCollectionViewCell.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    //MARK: - object
    let characterView: CharacterView = {
        let object = CharacterView.init(style: .unselect)
        return object
    }()

    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        contentView.addSubview(characterView)
    }
    
    private func configureLayout(){
        characterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - function
    func setData(_ image: UIImage){
        characterView.image = image
    }
}
