//
//  TracktService.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/2/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

class TracktService: BaseService<TraktTrendingMovieArray> {
    
    func getTrendingMovies(page: Int, completion: @escaping completionHandler<TraktTrendingMovieArray>) {
        guard let request = try? MovieServiceRouter.getTrendingMovies(page: page).asURLRequest() else {
            completion(.failure(error: ServiceError.badrequest))
            return
        }
        perform(request: request, completion: completion)
    }
}
