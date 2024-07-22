//
//  OnboardingVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit
import SnapKit

class OnboardingVC: BaseVC {
    
    //MARK: - object
    let titleImageView: UIImageView = {
        let object = UIImageView()
        object.image = ImageAssets.launchTitle
        object.contentMode = .scaleAspectFit
        return object
    }()
    
    let launchImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.image = ImageAssets.launch
        return object
    }()
    
    let startButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.start.title, for: .normal)
        return object
    }()
    
    //MARK: - properties
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAction()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(titleImageView)
        view.addSubview(startButton)
        view.addSubview(launchImageView)
    }
    
    override func configureLayout(){
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(launchImageView.snp.top).offset(-20)
        }
        
        launchImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(launchImageView.snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(20)
            make.height.equalTo(BaseButtonStyle.primary.height)
        }
    }
    
    //MARK: - function
    private func configureAction(){
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc func startButtonTapped(){
        let vc = ProfileSettingVC(type: .setting)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
