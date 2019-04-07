//
//  MoviedbService.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/2/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

class MoviedbService: BaseService<MoviedbDetail> {
    
    func getMovieDetail(id: String, completion: @escaping completionHandler<MoviedbDetail>) {
        guard let request = try? MovieServiceRouter.getDetailedInfo(movieId: id).asURLRequest() else {
            completion(.failure(error: ServiceError.badrequest))
            return
        }
        perform(request: request, completion: completion)
    }
}
