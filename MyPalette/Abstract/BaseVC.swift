//
//  BaseVC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

class BaseVC: UIViewController {
    
    //MARK: - property
    private var isChild: Bool = false
    
    //MARK: - life cycle
    init(title: String = "", isChild: Bool = false){
        super.init(nibName: nil, bundle: nil)
        self.isChild = isChild
        self.navigationItem.title = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(String(describing: type(of: self))) deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        if isChild {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageAssets.leftArrow, style: .done, target: self, action: #selector(dismissButtonTapped))
            navigationItem.leftBarButtonItem?.tintColor = .black
        }
        
        configureHierarchy()
        configureLayout()
        configureUI()
        bind()
    }
    
    //MARK: - configure function
    func configureHierarchy(){ }
    
    func configureLayout(){ }
    
    func configureUI(){ }
    
    //MARK: - function
    func bind(){}
    
    @objc private func dismissButtonTapped(){
        if isChild {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
}
