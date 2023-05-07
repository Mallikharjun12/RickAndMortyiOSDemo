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
    
    private var searchResultHandler:(()->Void)?
    
    private var searchText = ""
    
    //MARK: Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    //MARK: Public
    
    public func registerSearchResultHandler(_ block: @escaping ()->Void) {
        self.searchResultHandler = block
    }
    
    public func executeSearch() {
        //create request based on filters
             // print("SearchText:\(searchText)")
        //Build arguments
        var queryParams:[URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        //add filters
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({_, element in
            let key:RMSearchInputViewViewModel.DynamicOption = element.key
            let value:String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        //create Request
        let request = RMRequest(endpoint: config.type.endPoint,queryParameters: queryParams)
            // print("search url is:\(request.url?.absoluteString)")
        //send Api call
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Search Results Found:\(model.results.count)")
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
        //Notify view of results/Noresults/error
    }
    
    public func set(query text:String) {
        self.searchText = text
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
