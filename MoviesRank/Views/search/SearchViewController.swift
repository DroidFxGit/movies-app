//
//  SearchViewController.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 3/31/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }

    func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
