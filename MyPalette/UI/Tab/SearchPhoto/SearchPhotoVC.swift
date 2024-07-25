//
//  SearchPhotoVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

final class SearchPhotoVC: BaseVC {
    
    private lazy var searchController: UISearchController = {
        
        let object = UISearchController(searchResultsController: nil)
        object.searchBar.placeholder = Localized.searchBar_placeholder.text
        object.searchBar.tintColor = Color.primaryBlue
        object.hidesNavigationBarDuringPresentation = false
        object.searchBar.delegate = self
        return object
    }()
    
    private let emptyView: UIView = {
        let object = UIView()
        object.isHidden = true
        return object
    }()
    
    private let emptyLabel = {
        let object = UILabel()
        object.text = Localized.search_result_init.text
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
        //object.prefetchDataSource = self
        object.keyboardDismissMode = .onDrag
        object.register(SearchPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchPhotoCollectionViewCell.identifier)
        return object
    }()
    
    private let viewModel = SearchPhotoVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        emptyView.addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
}

extension SearchPhotoVC: UISearchBarDelegate {
    
}

extension SearchPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 4) / 2
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCollectionViewCell.identifier, for: indexPath) as! SearchPhotoCollectionViewCell
        cell.setData(isSelected: Bool.random())
        return cell
    }
}

//extension SearchPhotoVC: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        <#code#>
//    }
//}
