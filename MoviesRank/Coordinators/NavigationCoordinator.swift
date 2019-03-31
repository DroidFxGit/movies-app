//
//  NavigationCoordinator.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 3/31/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit

public class NavigationCoordinator: NSObject, CoordinatorProtocol {
    
    public var navigationController: UINavigationController
    
    public init(viewController: UIViewController) {
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.navigationBar.isTranslucent = false
        self.navigationController.view.backgroundColor = .white
        
        super.init()
    }
    
    public var rootViewController: UIViewController {
        return navigationController
    }
}
