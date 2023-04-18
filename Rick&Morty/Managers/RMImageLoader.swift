//
//  RMImageLoader.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 18/04/23.
//

import Foundation

final class RMImageLoader {
    static let shared = RMImageLoader()
    
    private init() {}
    
    private var imageDataCache = NSCache<NSString,NSData>()
    
    /// Get Image Content with URL
    /// - Parameters:
    ///   - url: source url
    ///   - completion: callback
    public func downloadImage(url:URL,completion:@escaping (Result<Data,Error>)->Void) {
        let key = url.absoluteString as NSString
        if let value = imageDataCache.object(forKey: key) {
            completion(.success(value as Data))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
