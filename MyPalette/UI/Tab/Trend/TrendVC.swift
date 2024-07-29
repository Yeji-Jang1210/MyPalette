//
//  TrendVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

protocol ReceiveUserInfoDelegate {
    func dataReceived()
}

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
        object.allowsSelection = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.inputViewWillAppearTrigger.value = ()
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
        
        viewModel.outputProfileImageNum.bind { [weak self] num in
            guard let self, let num else { return }
            characterView.image = Character.getImage(num: num)
        }
        
        viewModel.outputPhotoList.bind { [weak self] topics in
            guard let self else { return }
            tableView.reloadData()
        }
        
    }
    
    @objc
    func profileButtonTapped() {
        let vc = ProfileSettingVC(type: .edit)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TrendVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(TrendCollectionViewCell.self, forCellWithReuseIdentifier: TrendCollectionViewCell.identifier)
        cell.collectionView.tag = indexPath.row
        cell.setTitle(Topics.allCases[indexPath.row].title)
        cell.collectionView.reloadData()
        return cell
    }
}

extension TrendVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.height * 0.8
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPhotoList.value[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as! TrendCollectionViewCell
        
        let data = viewModel.outputPhotoList.value[collectionView.tag][indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.outputPhotoList.value[collectionView.tag][indexPath.row]
        let vc = PhotoDetailVC(photo: photo, isSaved: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! TrendCollectionViewCell
        cell.imageView.kf.cancelDownloadTask()
    }
}

extension TrendVC: ReceiveUserInfoDelegate {
    func dataReceived() {
        viewModel.inputProfileEditSucceed.value = ()
    }
}
