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
    @IBOutlet weak var emptyView: UIView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var dataSource: MoviesDataSource<HomeViewModel>!
    lazy var viewModel: HomeViewModel = {
        let model = HomeViewModel()
        model.delegate = self
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = MoviesDataSource(collectionView: collectionView, data: viewModel, type: .search)
        dataSource.datasourceDelegate = self
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        resetViewsToDefault()
    }
    
    func resetViewsToDefault() {
        collectionView.isHidden = true
        emptyView.isHidden = false
    }

    func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func fetchQuery(query: String) {
        viewModel.updatedMovies = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.collectionView.reloadData()
                
                let canShowCollectionView = strongSelf.viewModel.numberOfMovies > 0
                strongSelf.collectionView.isHidden = !canShowCollectionView
                strongSelf.emptyView.isHidden = canShowCollectionView
            }
        }
        viewModel.search(with: query)
    }
}

extension SearchViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchQuery(query:)), object: nil)
            self.perform(#selector(self.fetchQuery(query:)), with: searchText, afterDelay: 0.5)
        } else {
            resetViewsToDefault()
        }
    }
}

extension SearchViewController: HomeViewModelDelegate {
    func didShowError(error: Error) {
    }
}

extension SearchViewController: MoviesDataSourceDelegate {
    func willBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
        searchController.isActive = false
    }
}
