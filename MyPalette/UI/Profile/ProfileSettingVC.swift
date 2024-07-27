//
//  ProfileSettingVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit
import SnapKit
import Toast

protocol SendProfileImageId {
    func dataSend(id: Int)
}

final class ProfileSettingVC: BaseVC, SendProfileImageId {
    
    //MARK: - object
    lazy var characterView: CharacterView = {
        let object = CharacterView(style: .setting)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(characterViewTapped))
        object.addGestureRecognizer(gesture)
        return object
    }()
    
    lazy var nicknameTextField: UITextField = {
        let object = UITextField()
        object.attributedPlaceholder = NSAttributedString(string: Localized.nickname_placeholder.text,
                                                          attributes: [.font : BaseFont.medium.basicFont, .foregroundColor : Color.warmGray])
        object.borderStyle = .none
        object.addTarget(self, action: #selector(nicknameTextChanged), for: .editingChanged)
        return object
    }()
    
    let separatorLine: UIView = {
        let object = UIView()
        object.backgroundColor = Color.warmGray
        return object
    }()
    
    let nicknameStatusLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.basicFont
        return object
    }()
    
    lazy var completeButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.complete.text, for: .normal)
        object.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        return object
    }()
    
    lazy var deleteUserButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.attributedTitle = AttributedString(Localized.delete_user.title,
                                                  attributes: AttributeContainer([.font: BaseFont.mediumLarge.boldFont,.foregroundColor: Color.primaryBlue, .underlineStyle: NSUnderlineStyle.single.rawValue]))
        let object = UIButton()
        object.configuration = config
        object.isHidden = true
        object.addTarget(self, action: #selector(deleteUserButtonTapped), for: .touchUpInside)
        return object
    }()
    
    let mbtiLabel = {
        let object = UILabel()
        object.text = Localized.mbti.title
        object.font = BaseFont.large.boldFont
        return object
    }()
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.delegate = self
        object.dataSource = self
        object.register(MBTICollectionViewCell.self, forCellWithReuseIdentifier: MBTICollectionViewCell.identifier)
        return object
    }()
    
    //MARK: - properties
    private let viewModel = ProfileSettingVM()
    private let type: ProfileVCType
    var delegate: ReceiveUserInfoDelegate?
    
    //MARK: - life cycle
    init(type: ProfileVCType){
        self.type = type
        super.init(title: type.navTitle, isChild: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(characterView)
        view.addSubview(separatorLine)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameStatusLabel)
        view.addSubview(completeButton)
        view.addSubview(deleteUserButton)
        view.addSubview(mbtiLabel)
        view.addSubview(collectionView)
    }
    
    override func configureLayout(){
        characterView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(120)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(separatorLine.snp.horizontalEdges).inset(10)
            make.top.equalTo(characterView.snp.bottom).offset(40)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.height.equalTo(0.5)
        }
        
        nicknameStatusLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nicknameTextField.snp.horizontalEdges)
            make.top.equalTo(separatorLine.snp.bottom).offset(12)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.horizontalEdges.equalTo(separatorLine.snp.horizontalEdges)
            make.height.equalTo(BaseButtonStyle.primary.height)
        }
        
        deleteUserButton.snp.makeConstraints { make in
            make.centerX.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(separatorLine.snp.leading)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mbtiLabel.snp.top)
            make.trailing.equalTo(separatorLine.snp.trailing)
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(60)
            make.height.equalTo(120)
        }
    }
    
    override func configureUI(){
        if type == .edit {
            completeButton.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localized.save_button.title, style: .done, target: self, action: #selector(updateData))
            navigationItem.rightBarButtonItem?.tintColor = Color.black
            navigationItem.rightBarButtonItem?.tag = type.rawValue
            deleteUserButton.isHidden = false
        }
    }
    
    override func bind(){
        viewModel.outputImageNum.bind { [weak self] num in
            guard let self else { return }

            characterView.image = Character.getImage(num: num)
        }
        
        viewModel.outputNickname.bind { [weak self] nickname in
            guard let self else { return }
            nicknameTextField.text = nickname
        }
        
        viewModel.outputNicknameStatus.bind { [weak self] (status, isValid) in
            guard let self, let isValid else { return }
            nicknameStatusLabel.text = status?.message
            nicknameStatusLabel.textColor = isValid ? Color.primaryBlue : Color.primaryRed
        }
        
        viewModel.outputIsNicknameValid.bind { [weak self] result in
            guard let self else { return }
            switch self.type {
            case .setting:
                completeButton.isEnabled = result
            case .edit:
                navigationItem.rightBarButtonItem?.isEnabled = result
            }
        }
        
        viewModel.outputIsUpdate.bind { [weak self] result in
            guard let self, let result else { return }
            if result {
                let vc = MainTBC()
                changeRootViewController(vc)
            } else {
                view.makeToast(Localized.user_info_saved_error.text)
            }
        }
        
        viewModel.outputIsSaved.bind { [weak self] result in
            guard let self, let result else { return }
            if result {
                delegate?.dataReceived()
                navigationController?.popViewController(animated: true)
            } else {
                view.makeToast(Localized.user_info_saved_error.text)
            }
        }
        
        viewModel.outputIsDeleteSucceeded.bind { [weak self] result in
            guard let self, let result else { return }
            
            if result {
                let nvc = UINavigationController(rootViewController: OnboardingVC())
                changeRootViewController(nvc)
            }
        }
        
    }
    
    //MARK: - function
    @objc 
    func characterViewTapped(){
        let vc = SelectCharacterVC(title: type.navTitle, isChild: true)
        //delegate 연결
        vc.delegate = self
        vc.viewModel.inputCharacterNum.value = viewModel.outputImageNum.value
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func acceptButtonTapped(){
        viewModel.inputSaveTrigger.value = ()
    }
    
    @objc
    func updateData(){
        viewModel.inputUpdateTrigger.value = ()
    }
    
    @objc
    func deleteUserButtonTapped(){
        self.presentAlert(localized: Localized.delete_user_dlg) {
            self.viewModel.inputDeleteUserTrigger.value = ()
        } cancel: {
            
        }
    }
    
    @objc 
    func nicknameTextChanged(_ sender: UITextField) {
        viewModel.inputNickname.value = sender.text
    }
    
    @objc
    func mbtiButtonTapped(_ sender: CircleButton){
        sender.isSelected.toggle()
    }
    
    func dataSend(id: Int) {
        viewModel.inputImageNum.value = id
    }
}

extension ProfileSettingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MBTI.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.identifier, for: indexPath) as! MBTICollectionViewCell
        cell.mbtiButton.tag = indexPath.row
        cell.setTitle(title: MBTI.allCases[indexPath.row].rawValue)
        cell.mbtiButton.addTarget(self, action: #selector(mbtiButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 4
        return CGSize(width: width, height: width)
    }
}
