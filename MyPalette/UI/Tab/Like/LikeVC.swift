//
//  LikeVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

final class LikeVC: BaseVC {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.delegate = self
        object.dataSource = self
        object.keyboardDismissMode = .onDrag
        object.register(LikeCollectionViewCell.self, forCellWithReuseIdentifier: LikeCollectionViewCell.identifier)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LikeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 4) / 2
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCollectionViewCell.identifier, for: indexPath) as! LikeCollectionViewCell
        cell.setData(isSelected: Bool.random())
        return cell
    }
}
