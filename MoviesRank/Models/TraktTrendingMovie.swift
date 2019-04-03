//
//  TraktTrendingMovie.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/2/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

typealias TraktTrendingMovieArray = [TraktTrendingMovie]

public struct TraktTrendingMovie: Codable {
    public let watchers: Int
    public let movie: TraktMovie
}


public struct TraktMovie: Codable {
    public let title: String
    public let year: Int?
    public let ids: ID
    
    enum CodingKeys: String, CodingKey {
        case title
        case year
        case ids
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: CodingKeys.title)
        year = try container.decodeIfPresent(Int.self, forKey: CodingKeys.year)
        ids = try container.decode(ID.self, forKey: CodingKeys.ids)
    }
}

public struct ID: Codable {
    public let trakt: Int
    public let slug: String
    public let tvdb: Int?
    public let imdb: String?
    public let tmdb: Int?
    public let tvRage: Int?
    
    enum CodingKeys: String, CodingKey {
        case trakt
        case slug
        case tvdb
        case imdb
        case tmdb
        case tvRage = "tvrage"
    }
}
