//
//  SearchPhotoVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

enum SearchStatus {
    case initialScreen
    case resultIsEmpty
    case searchSuccess
    
    var message: String {
        switch self {
        case .initialScreen:
            return Localized.search_result_init.text
        case .resultIsEmpty:
            return Localized.search_result_empty.text
        case .searchSuccess:
            return ""
        }
    }
}

final class SearchPhotoVC: BaseVC {
    
    private lazy var searchController: UISearchController = {
        let object = UISearchController(searchResultsController: nil)
        object.searchBar.placeholder = Localized.searchBar_placeholder.text
        object.searchBar.tintColor = Color.primaryBlue
        object.hidesNavigationBarDuringPresentation = false
        object.searchBar.delegate = self
        return object
    }()
    
    private let emptyLabel = {
        let object = UILabel()
        object.font = BaseFont.large.boldFont
        return object
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.delegate = self
        object.dataSource = self
        object.prefetchDataSource = self
        object.keyboardDismissMode = .onDrag
        object.register(SearchPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchPhotoCollectionViewCell.identifier)
        return object
    }()
    
    private let viewModel = SearchPhotoVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
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
    
    override func configureUI() {
        super.configureUI()
        configureNavigationBar()
    }
    
    private func configureNavigationBar(){
        navigationItem.scrollEdgeAppearance = UINavigationBarAppearance()
        navigationItem.scrollEdgeAppearance?.backgroundColor = Color.white
        navigationItem.scrollEdgeAppearance?.shadowColor = Color.darkGray
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func bind() {
        super.bind()
        
        viewModel.outputSearchResultStatus.bind { [weak self] status in
            guard let self else { return }
            emptyLabel.text = status.message
        }
        
        viewModel.outputSearchResult.bind { [weak self] photos in
            guard let self else { return }

            collectionView.reloadData()
            if viewModel.page == 1 && !photos.isEmpty {
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        
        viewModel.outputPresentToastMessage.bind { [weak self] message in
            guard let self, let message else { return }
            
            DispatchQueue.main.async {
                self.view.makeToast(message)
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc 
    func saveButtonTapped(_ sender: UIButton){
        sender.isSelected.toggle()
        viewModel.inputIsSaveButtonSelected.value = (sender.isSelected, sender.tag)
    }
}

extension SearchPhotoVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text ,!text.isEmpty {
            self.viewModel.inputSearchText.value = text
        }
    }
}

extension SearchPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 4) / 2
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputSearchResult.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCollectionViewCell.identifier, for: indexPath) as! SearchPhotoCollectionViewCell
        cell.saveButton.tag = indexPath.row
        cell.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let photo = viewModel.outputSearchResult.value[indexPath.row]
        cell.setData(photo: photo, isSelected: viewModel.photoIsSaved(photo.id))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.outputSearchResult.value[indexPath.row]
        let vc = PhotoDetailVC(photo: photo)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! SearchPhotoCollectionViewCell
        cell.imageView.kf.cancelDownloadTask()
    }
}

extension SearchPhotoVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if self.viewModel.outputSearchResult.value.count - 2 == indexPath.row && viewModel.isEnd {
                viewModel.inputNextPageTrigger.value = ()
            }
        }
    }
}
