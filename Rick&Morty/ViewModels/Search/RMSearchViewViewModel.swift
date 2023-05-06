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
    
    private var optionMap:[RMSearchInputViewViewModel.DynamicOption:String] = [:]
    
    private var optionMapUpdateBlock:(((RMSearchInputViewViewModel.DynamicOption,String))->Void)?
    
    //MARK: Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    //MARK: Public
    
    public func executeSearch() {
        //create request based on filters
        //send Api call
        //Notify view of results/Noresults/error
    }
    
    public func set(value:String, option:RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option,value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption,String))->Void) {
        self.optionMapUpdateBlock = block
    }
}
