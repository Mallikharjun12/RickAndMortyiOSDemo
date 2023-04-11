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
                                   completion: @escaping(Result<T, Error>)->()
    ) {
        
    }
}
