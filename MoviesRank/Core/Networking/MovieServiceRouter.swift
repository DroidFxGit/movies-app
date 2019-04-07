//
//  MovieServiceRouter.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/2/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
}

typealias Parameters = [String: Any]?

enum MovieServiceRouter: URLRequestConvertible {
    case getTrendingMovies(page: Int)
    case getDetailedInfo(movieId: String)
    case search(query: String)
    
    var path: String {
        switch self {
        case .getTrendingMovies(_):
            return "movies/trending"
        case .getDetailedInfo(let movieId):
            let moviedbVersion = ConfigurationUtils.valueFromDictionary(.moviedbVersionAPI)
            return "\(moviedbVersion)/find/\(movieId)"
        case .search:
            return "search"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getTrendingMovies(let page):
            return ["page": page, "limit": 10]
        case .getDetailedInfo(_):
            let moviedbAPIkey = ConfigurationUtils.valueFromDictionary(.moviedbAPIkey)
            return [ "api_key": moviedbAPIkey,
                     "language": "en-US",
                     "external_source": "imdb_id"
            ]
        case .search(let query):
            return ["type": "movie", "query": query]
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .getTrendingMovies, .search:
            let tracktBaseUrl = ConfigurationUtils.valueFromDictionary(.tracktBaseUrl)
            let url = URL(fileURLWithPath: tracktBaseUrl)
            return request(baseURL: url, path: path, method: .get, parameters: parameters)
        case .getDetailedInfo:
            let moviedbBaseUrl = ConfigurationUtils.valueFromDictionary(.moviedbBaseUrl)
            let url = URL(fileURLWithPath: moviedbBaseUrl)
            return request(baseURL: url, path: path, method: .get, parameters: parameters)
        }
    }
    
    private func request(baseURL: URL, path: String, method: HTTPMethod, parameters: Parameters=nil) -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {
            let urlParams = parameters.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }).joined(separator: "&")
            urlRequest = URLRequest(url: baseURL.appendingPathComponent(path + urlParams))
        }
        
        switch self {
        case .getTrendingMovies, .search:
            let apiVersion = ConfigurationUtils.valueFromDictionary(.tracktVersionAPI)
            let apiKey = ConfigurationUtils.valueFromDictionary(.tracktAPIkey)
            urlRequest.setValue(apiVersion, forHTTPHeaderField: "trakt-api-version")
            urlRequest.setValue(apiKey, forHTTPHeaderField: "trakt-api-key")
        case .getDetailedInfo:
            break
        }
        
        return urlRequest
    }
}
