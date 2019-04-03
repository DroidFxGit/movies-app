//
//  BaseService.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/2/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

enum ServiceResponse<T> {
    case success(response: T)
    case failure(error: Error)
}

enum ServiceError: Error {
    case badrequest
}

enum StatusCode: Int {
    case success = 200
    
    static func value(_ key: StatusCode) -> Int {
        return key.rawValue
    }
}

typealias completionHandler<T> = (ServiceResponse<T>) -> Void

class BaseService<T: Codable> {
    
    fileprivate let session = URLSession(configuration: .default)
    
    func perform(request: URLRequest, completion: @escaping completionHandler<T>) {
        
        let dataTask = session.dataTask(with: request) { [weak self] (data, urlResponse, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(.failure(error: error))
            }
            
            let successStatus = StatusCode.value(.success)
            guard let response = urlResponse as? HTTPURLResponse, response.statusCode == successStatus, let data = data else {
                completion(.failure(error: ServiceError.badrequest))
                return
            }
            
            strongSelf.processSuccessResponse(data: data, completion: completion)
        }
        dataTask.resume()
    }
    
    func parse(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func processSuccessResponse(data: Data, completion: @escaping completionHandler<T>) {
        do {
            let responseModel = try parse(data: data)
            completion(.success(response: responseModel))
        } catch let error {
            completion(.failure(error: error))
        }
    }
}
