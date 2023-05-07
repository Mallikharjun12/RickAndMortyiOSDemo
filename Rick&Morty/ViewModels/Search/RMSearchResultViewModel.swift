//
//  RMSearchResultViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 07/05/23.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
}
