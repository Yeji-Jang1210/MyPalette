//
//  MainTBC.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

class MainTBC: UITabBarController {
    
    enum Tab: Int, CaseIterable {
        case trend
        case randomPhoto
        case searchPhoto
        case like
        
        var title: String {
            switch self {
            case .trend:
                return Localized.trend.title
            case .randomPhoto:
                return Localized.randomPhoto.title
            case .searchPhoto:
                return Localized.searchPhoto.title
            case .like:
                return Localized.like.title
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .trend:
                return ImageAssets.trend
            case .randomPhoto:
                return ImageAssets.random
            case .searchPhoto:
                return ImageAssets.search
            case .like:
                return ImageAssets.like
            }
        }
        
        var vc: UIViewController {
            switch self {
            case .trend:
                return UINavigationController(rootViewController: TrendVC())
            case .randomPhoto:
                return UINavigationController(rootViewController: RandomPhotoVC(title: self.title))
            case .searchPhoto:
                return UINavigationController(rootViewController: SearchPhotoVC(title: self.title))
            case .like:
                return UINavigationController(rootViewController: SavedPhotoVC(title: self.title))
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tabBar.tintColor = Color.black
        tabBar.unselectedItemTintColor = Color.warmGray
        
        let viewControllers = Tab.allCases.map { tab -> UIViewController in
            let vc = tab.vc
            vc.tabBarItem = UITabBarItem(title: "", image: tab.icon, tag: tab.rawValue)
            
            return vc
        }
        
        self.viewControllers = viewControllers
    }
}
