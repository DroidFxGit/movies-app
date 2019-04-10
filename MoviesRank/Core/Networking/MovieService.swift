//
//  MovieService.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/6/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

typealias completionHandlerMovies<T, S> = (ServiceResponse<T>?, ServiceResponse<S>) -> Void

class MovieService {
    
    private let tracktService = TracktService()
    private let moviedbService = MoviedbService()
    private var movieDetailArray: MoviedbDetailArray = []
    
    func requestDetailedTrendingMovies(page: Int, completion: @escaping completionHandlerMovies<TraktTrendingMovieArray, MoviedbDetailArray>) {
        
        tracktService.getTrendingMovies(page: page) { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let moviesArray):
                print("response movies titles: \(moviesArray)")
                strongSelf.handleRequestQueue(trendingMovies: moviesArray, completion: completion)
            case .failure(let error):
                completion(nil, .failure(error: error))
            }
        }
    }
    
    func searchMovie(with query: String, completion: @escaping completionHandlerMovies<TraktTrendingMovieArray, MoviedbDetailArray>) {
        tracktService.searchMovie(with: query) { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let moviesArray):
                print("response movies titles: \(moviesArray)")
                strongSelf.handleRequestQueue(trendingMovies: moviesArray, completion: completion)
            case .failure(let error):
                completion(nil, .failure(error: error))
            }
        }
    }
    
    private func handleRequestQueue(trendingMovies: TraktTrendingMovieArray, completion: @escaping completionHandlerMovies<TraktTrendingMovieArray, MoviedbDetailArray>) {
        
        movieDetailArray = []
        let idArray: [String] = trendingMovies.map { $0.movie.ids.imdb ?? "" }
        let backgroundQueue = DispatchQueue.global(qos: .default)
        let group = DispatchGroup()
        
        if idArray.count == 0 {
            completion(nil, .failure(error: ServiceError.unknown))
            return
        }
        
        for idMovie in idArray {
            group.enter()
            backgroundQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.moviedbService.getMovieDetail(id: idMovie, completion: { response in
                    switch response {
                    case .success(let movieDetail):
                        strongSelf.movieDetailArray.append(movieDetail)
                    case .failure(let error):
                        //keep going with queue unless error is different
                        if case ServiceError.badrequest = error {
                            break
                        } else {
                            completion(nil, .failure(error: error))
                        }
                    }
                    group.leave()
                })
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.movieDetailArray.count > 0 {
                completion(.success(response: trendingMovies), .success(response: strongSelf.movieDetailArray))
            } else {
                completion(nil, .failure(error: ServiceError.unknown))
            }
        }
        
    }
}
