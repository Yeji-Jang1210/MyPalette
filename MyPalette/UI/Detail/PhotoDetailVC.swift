//
//  PhotoDetailVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/24/24.
//

import UIKit
import Kingfisher
import SnapKit
import Toast

final class PhotoDetailVC: BaseVC {
    
    private enum PhotoInfo: CaseIterable{
        case size
        case views
        case downloads
        
        var title: String {
            switch self {
            case .size:
                return Localized.size.title
            case .views:
                return Localized.views.title
            case .downloads:
                return Localized.downloads.title
            }
        }
    }
    
    private lazy var scrollView = UIScrollView()
    private var contentView = UIView()
    
    private let profileView = {
       let object = UserProfileView()
        return object
    }()
    
    private let photoImageView = {
        let object = UIImageView()
        object.clipsToBounds = true
        object.contentMode = .scaleAspectFill
        object.backgroundColor = .systemGray6
        return object
    }()
    
    private let infoLabel = {
        let object = UILabel()
        object.setContentHuggingPriority(.required, for: .horizontal)
        object.text = Localized.info.text
        object.font = BaseFont.large.boldFont
        return object
    }()
    
    private let sizeLabel = UILabel()
    private let viewsLabel = UILabel()
    private let downloadLabel = UILabel()
    
    private let sizeValueLabel = UILabel()
    private let viewsValueLabel = UILabel()
    private let downloadValueLabel = UILabel()
    
    private lazy var titleLabels = [sizeLabel, viewsLabel, downloadLabel]
    private lazy var valueLabels = [sizeValueLabel, viewsValueLabel, downloadValueLabel]

    private let stackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.alignment = .top
        object.setContentHuggingPriority(.defaultLow, for: .horizontal)
        object.distribution = .fillProportionally
        return object
    }()
    
    private let viewModel: PhotoDetailVM
    
    init(photo: Photo){
        viewModel = PhotoDetailVM(photo: photo)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(stackView)
        configureStackView()
        contentView.addSubview(profileView)
        contentView.addSubview(photoImageView)
    }
    
    func configureStackView(){
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        
        for index in PhotoInfo.allCases.indices {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(titleLabels[index])
            stackView.addArrangedSubview(valueLabels[index])
            verticalStackView.addArrangedSubview(stackView)
        }
        
        stackView.addArrangedSubview(verticalStackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(stackView.snp.top).offset(-20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
            make.leading.equalTo(photoImageView.snp.leading).offset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(infoLabel.snp.trailing).offset(40)
            make.trailing.bottom.equalTo(contentView).inset(20)
            make.top.equalTo(infoLabel)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        for (index, type) in PhotoInfo.allCases.enumerated() {
            titleLabels[index].font = BaseFont.mediumLarge.boldFont
            titleLabels[index].text = type.title

            valueLabels[index].font = BaseFont.medium.basicFont
            valueLabels[index].textAlignment = .right
            valueLabels[index].setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        }
    }
    
    override func bind() {
        super.bind()
        viewModel.outputPhoto.bind { [weak self] photo in
            guard let self, let photo else { return }
            
            profileView.imagePath = photo.user.profileImage.medium
            profileView.userName = photo.user.name
            profileView.updateDate = photo.createdDateText
            sizeValueLabel.text = photo.sizeText
        }
        
        viewModel.outputStatistics.bind { [weak self] statistics in
            guard let self, let statistics else { return }
            
            viewsValueLabel.text = statistics.views.total.formatted()
            downloadValueLabel.text = statistics.downloads.total.formatted()
        }
        
        viewModel.outputSetPhotoImageTrigger.bind { [weak self] path in
            guard let self, let path else { return }
            setPhotoImageView(path: path)
        }
    }
    
    private func setPhotoImageView(path: String){
        guard let url = URL(string: path) else { return }
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: url, placeholder: nil, options: nil) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                viewModel.inputSetImageSuccessTrigger.value = ()
            case .failure(_):
                photoImageView.kf.cancelDownloadTask()
                view.makeToast("이미지를 불러오는데 실패했습니다.")
            }
        }
    }
}
