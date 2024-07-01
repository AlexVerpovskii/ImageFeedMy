//
//  RootTabBarViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 13.06.2024.
//

import UIKit

final class RootTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tabBar.tintColor = .white
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .ypBlack
        tabBar.standardAppearance = tabBarAppearance
        
        let profileVC = ProfileVC()
        let defaultTabBarImageProfile = UIImage(named: Constants.ImageNames.tabBarImagRight)
        let profileBarItem = UITabBarItem(title: Constants.Other.empty, image: defaultTabBarImageProfile, tag: 1)
        profileVC.tabBarItem = profileBarItem
        
        let imageListVC = ImagesListVC()
        let defaultTabBarIamgeImageList = UIImage(named: Constants.ImageNames.tabBarImageLeft)
        let imageListBarItem = UITabBarItem(title: Constants.Other.empty, image: defaultTabBarIamgeImageList, tag: 0)
        imageListVC.tabBarItem = imageListBarItem
        
        viewControllers = [imageListVC, profileVC]
    }
}
