//
//  HomeViewModel.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/7/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
    func didShowError(error: Error)
}

class HomeViewModel {
    private let service = MovieService()
    
    fileprivate var isFetching = false
    fileprivate var page = 1
    fileprivate var selectedMovie: MoviedbDetail?
    
    weak var delegate: HomeViewModelDelegate?
    
    var movies = [MoviedbDetail]() {
        didSet {
            updatedMovies()
        }
    }
    
    var numberOfMovies: Int {
        get {
            return movies.count
        }
    }
    
    var updatedMovies: () -> () = {}
    
    func getMovies() {
        if isFetching {
            return
        }
        isFetching = true
        service.requestDetailedTrendingMovies(page: page) { [weak self] (_, detailedResponse) in
            guard let strongSelf = self else { return }
            strongSelf.isFetching = false
            strongSelf.page += 1
            
            switch detailedResponse {
            case .success(let response):
                strongSelf.movies += response
                print("number of items: \(strongSelf.movies.count)")
            case .failure(let error):
                strongSelf.delegate?.didShowError(error: error)
            }
        }
    }
    
    func getMovie(at index: IndexPath) -> MoviedbDetail {
        return movies[index.row]
    }
}
