//
//  TrendVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

final class TrendVC: BaseVC {
    
    private let headerView = {
        let object = UIView()
        object.backgroundColor = .white
        return object
    }()
    
    private let titleLabel = {
        let object = UILabel()
        object.text = Localized.trend.title
        object.font = .systemFont(ofSize: 36, weight: .heavy)
        return object
    }()
    
    private lazy var characterView = {
        let object = CharacterView(style: .select)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        object.addGestureRecognizer(gesture)
        return object
    }()
    
    private lazy var tableView = {
        let object = UITableView()
        object.separatorStyle = .none
        object.delegate = self
        object.dataSource = self
        object.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
        return object
    }()
    
    private let viewModel = TrendVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(tableView)
        view.addSubview(headerView)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(characterView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
        }
        
        characterView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func bind() {
        super.bind()
        
        viewModel.outputImageNum.bind { [weak self] num in
            guard let self, let num else { return }
            characterView.image = Character.getImage(num: num)
        }
        
    }
    
    @objc
    func profileButtonTapped() {
        print(#function)
    }
}

extension TrendVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(TrendCollectionViewCell.self, forCellWithReuseIdentifier: TrendCollectionViewCell.identifier)
        return cell
    }
}

extension TrendVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = UIScreen.main.bounds.width / 2 - 20
        let width = collectionView.bounds.height * 0.8
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as! TrendCollectionViewCell
        cell.setData()
        return cell
    }
}
