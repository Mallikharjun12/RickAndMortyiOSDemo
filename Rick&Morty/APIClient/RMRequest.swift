//
//  RMRequest.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 11/04/23.
//

import Foundation

/// Object that represents a single Api cal
final class RMRequest {
    
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired Endpoint
    private let endpoint:RMEndpoint
    
    /// Path Components for API, if any
    private let pathComponents:[String]
    
    /// Query arguments for API, if any
    private let queryParameters:[URLQueryItem]
    
    /// Constructed url for the api in string format
    private var urlString:String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {
                    return nil
                }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    
    /// Computed and constructed API Url
    public var url:URL? {
        return URL(string: urlString)
    }
    
    /// Desired httpMethod
    public let httpMethod = "GET"
    
    //MARK: Public init
    
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target Endpoint
    ///   - pathComponents: collection of path components
    ///   - queryParameters: collection of query parameters
    public init(
            endpoint: RMEndpoint,
            pathComponents: [String] = [] ,
            queryParameters: [URLQueryItem] = []
             ) {
            self.endpoint = endpoint
            self.pathComponents = pathComponents
            self.queryParameters = queryParameters
    }
}
