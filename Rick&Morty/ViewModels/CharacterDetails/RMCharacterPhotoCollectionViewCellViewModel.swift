//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 22/04/23.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageUrl:URL?
    
    init(imageUrl:URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion:@escaping (Result<Data,Error>)->Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url: url, completion: completion)
    }
}
