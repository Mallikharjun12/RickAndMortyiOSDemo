//
//  RMEpisodeInfoCollectionViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 24/04/23.
//

import Foundation

final class RMEpisodeInfoCollectionViewCellViewModel {
    
    public let value:String
    public let title:String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
