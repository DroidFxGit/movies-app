//
//  HomeViewCoordinator.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 3/31/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit
import Foundation

public class HomeViewCoordinator: CoordinatorProtocol {
    
    fileprivate let navCoordinator: NavigationCoordinator!
    
    init() {
        let homeView = HomeViewController()
        navCoordinator = NavigationCoordinator(viewController: homeView)
    }
    
    public var rootViewController: UIViewController {
        return navCoordinator.rootViewController
    }
}
