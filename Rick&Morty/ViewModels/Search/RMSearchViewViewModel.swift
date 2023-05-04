//
//  RMSearchViewViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 01/05/23.
//

import Foundation

//Responsibilities

// - show search Results
// - show No results view
// - kick off api requests

final class RMSearchViewViewModel {
    
    let config:RMSearchViewController.Config
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
