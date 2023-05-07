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
    
    private var searchResultHandler:((RMSearchResultViewModel)->Void)?
    
    private var searchText = ""
    
    //MARK: Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    //MARK: Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel)->Void) {
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
        switch config.type.endPoint {
        case .character:
            makeSearchApiCall(request: request, RMGetAllCharactersResponse.self)
        case .location:
            makeSearchApiCall(request: request, RMGetAllLocationsResponse.self)
        case .episode:
            makeSearchApiCall(request: request, RMGetAllEpisodesResponse.self)
        }
        //Notify view of results/Noresults/error
    }
    
    private func makeSearchApiCall<T:Codable> (request:RMRequest, _ type: T.Type) {
        RMService.shared.execute(request, expecting: type) {[weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResults(model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func processSearchResults(_ model:Codable) {
        var resultsVM:RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
        } else if let episodeResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )
            }))
        } else if let locationResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        
        if let results = resultsVM {
            self.searchResultHandler?(results)
        } else {
            // fall back error
        }
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
