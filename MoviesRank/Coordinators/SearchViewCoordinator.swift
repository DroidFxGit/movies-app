//
//  SearchViewCoordinator.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 3/31/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit
import Foundation

public class SearchViewCoordinator: CoordinatorProtocol {
    
    fileprivate let navCoordinator: NavigationCoordinator!
    
    init() {
        let searchView = SearchViewController()
        navCoordinator = NavigationCoordinator(viewController: searchView)
    }
    
    public var rootViewController: UIViewController {
        return navCoordinator.rootViewController
    }
}
