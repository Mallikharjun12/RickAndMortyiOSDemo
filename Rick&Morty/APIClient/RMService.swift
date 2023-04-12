//
//  RMService.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 11/04/23.
//

import Foundation

/// Primary API Service to get RickAndMorty Data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    /// privatised constructoe
    private init() {}
    
    
    /// Send RickAndMorty Api call
    /// - Parameters:
    ///   - request: request instance
    ///   - type: type of object we expect to get back
    ///   - completion: callback with data or error
    public func execute<T:Codable>(_ request:RMRequest,
                                   expecting type: T.Type,
                                   completion: @escaping(Result<T, Error>)->Void
    ) {
        guard let request = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: Private
    
    private func request(from rmRequest:RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}

enum RMServiceError:Error {
    case failedToCreateRequest
    case failedToGetData
}
