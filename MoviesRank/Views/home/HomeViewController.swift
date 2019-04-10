//
//  HomeViewController.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 3/31/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let kSections = 1
    private let itemsPerRow: CGFloat = 1
    private let kHeightRow: CGFloat = 200.0
    private let kHeightFooter: CGFloat = 40.0
    
    private var dataSource: MoviesDataSource<HomeViewModel>!
    lazy var viewModel: HomeViewModel = {
        let model = HomeViewModel()
        model.delegate = self
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trending"
        dataSource = MoviesDataSource(collectionView: collectionView, data: viewModel, type: .trending)
        fetchMovies()
    }
    
    func fetchMovies() {
        viewModel.updatedMovies = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.collectionView.reloadData()
            }
        }
        viewModel.getMovies()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didShowError(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
