//
//  TabbarCoordinator.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 3/31/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit
import Foundation

final class TabbarCoordinator: NSObject {
    
    fileprivate weak var window: UIWindow?
    fileprivate var homeViewCoordinator: HomeViewCoordinator?
    fileprivate var searchViewCoordinator: SearchViewCoordinator?
    
    lazy var mainTabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.delegate = self
        return tabBarController
    }()
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    fileprivate func configureMainTabBar() {
        homeViewCoordinator = HomeViewCoordinator()
        searchViewCoordinator = SearchViewCoordinator()
        var controllers: [UIViewController] = []
        
        let homeView = homeViewCoordinator?.rootViewController
        let homeTabBarTitle = "Movies"
        homeView?.tabBarItem = UITabBarItem(title: homeTabBarTitle, image: .movieImageIcon, selectedImage: .movieImageIcon)
        
        let searchView = searchViewCoordinator?.rootViewController
        let searchTabBarTitle = "Search"
        searchView?.tabBarItem = UITabBarItem(title: searchTabBarTitle, image: .searchImageIcon, selectedImage: .searchImageIcon)
        
        controllers.append(homeView!)
        controllers.append(searchView!)
        
        mainTabBarController.viewControllers = controllers
        window?.rootViewController = mainTabBarController
    }
}

extension TabbarCoordinator: Startable {
    func start() {
        configureMainTabBar()
        window?.makeKeyAndVisible()
    }
}

extension TabbarCoordinator: UITabBarControllerDelegate {
    
}
