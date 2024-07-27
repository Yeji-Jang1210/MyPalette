//
//  ImageAssets.swift
//  MyPalette
//
//  Created by 장예지 on 7/22/24.
//

import UIKit

struct ImageAssets {
    private init(){}
    
    //launch
    static let launchTitle = UIImage(named: "launch")
    static let launch = UIImage(named: "launchMainImage")
    
    //tabBarIcon
    static let trend = UIImage(named: "tab_trend")
    static let random = UIImage(named: "tab_random")
    static let search = UIImage(named: "tab_search")
    static let like = UIImage(named: "tab_like")
    
    //icon
    static let leftArrow = UIImage(systemName: "chevron.left")
    static let camera = UIImage(systemName: "camera.fill")
    static let star = UIImage(systemName: "star.fill")
    static let sort = UIImage(named: "sort")
    
    //like Button
    static let likeButton = UIImage(named: "like")
    static let likeButtonInActive = UIImage(named: "like_inactive")
    
    //saveButton
    static let saveButtonActive = UIImage(named: "like_circle")
    static let saveButtonInActive = UIImage(named: "like_circle_inactive")
    
}
