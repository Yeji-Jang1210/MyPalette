//
//  RandomPhotoVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

final class RandomPhotoVC: BaseVC {
    
    lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.isPagingEnabled = true
        object.delegate = self
        object.dataSource = self
        object.register(RandomPhotoCollectionViewCell.self, forCellWithReuseIdentifier: RandomPhotoCollectionViewCell.identifier)
        if let top = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            object.contentInset = UIEdgeInsets(top: -top, left: 0, bottom: 0, right: 0)
        }
        object.showsVerticalScrollIndicator = false
        return object
    }()
    
    
    let paginationView = PaginationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(collectionView)
        view.addSubview(paginationView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        paginationView.snp.makeConstraints { make in
            make.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    let viewModel = RandomPhotoVM()
    
    override func bind() {
        super.bind()
        
        viewModel.outputRandomPhoto.bind { [weak self] photos in
            guard let self, photos != nil else { return }
            collectionView.reloadData()
        }
    }
}

extension RandomPhotoVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputRandomPhoto.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomPhotoCollectionViewCell.identifier, for: indexPath) as! RandomPhotoCollectionViewCell
        if let photo = viewModel.outputRandomPhoto.value?[indexPath.row] {
            cell.setData(photo)
        }
        
        return cell
    }
    
    
}
