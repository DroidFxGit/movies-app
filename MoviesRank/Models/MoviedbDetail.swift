//
//  MoviedbDetail.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/2/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

public struct MoviedbDetail: Codable {
    public let movieResults: [MovieResults]
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
    }
}

public struct MovieResults: Codable {
    public let title: String
    public let date: String
    public let overview: String
    public let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case date = "release_date"
        case overview
        case posterPath = "poster_path"
    }
}
