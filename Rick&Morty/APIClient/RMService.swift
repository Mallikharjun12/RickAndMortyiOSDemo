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
    ///   - completion: callback with data or error
    public func execute(_ request:RMRequest, completion: @escaping()->() ) {
        
    }
}
