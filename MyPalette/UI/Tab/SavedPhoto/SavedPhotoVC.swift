//
//  SavedPhotoVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

final class SavedPhotoVC: BaseVC {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.delegate = self
        object.dataSource = self
        object.keyboardDismissMode = .onDrag
        object.register(SavedPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SavedPhotoCollectionViewCell.identifier)
        return object
    }()
    
    private let emptyLabel = {
        let object = UILabel()
        object.text = Localized.save_list_isEmpty.text
        object.font = BaseFont.mediumLarge.boldFont
        return object
    }()
    
    private let viewModel = SavedPhotoVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputViewAppearTrigger.value = ()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.outputSavedPhotoList.bind { [weak self] photos in
            guard let self, let photos else { return }
            
            emptyLabel.isHidden = !photos.isEmpty
            collectionView.reloadData()
        }
        
        viewModel.outputPresentToast.bind { [weak self] present in
            guard let self, let present else { return }
            view.makeToast(Localized.save_unselect_message.message)
        }
        
        viewModel.outputPhoto.bind { [weak self] photo in
            guard let self, let photo else { return }
            let vc = PhotoDetailVC(photo: photo)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func savedButtonTapped(_ sender: UIButton){
        viewModel.inputSaveButtonTapped.value = sender.tag
    }
}

extension SavedPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 4) / 2
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputSavedPhotoList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedPhotoCollectionViewCell.identifier, for: indexPath) as! SavedPhotoCollectionViewCell
        cell.saveButton.tag = indexPath.row
        cell.saveButton.addTarget(self, action: #selector(savedButtonTapped), for: .touchUpInside)
        if let id = viewModel.outputSavedPhotoList.value?[indexPath.row].photoId{
            cell.imageView.image = FileManager.loadImageToDocument(filename: id)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputTappedPhoto.value = indexPath.row
    }
}
