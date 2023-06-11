//
//  RMSearchResultType.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 07/05/23.
//

import Foundation


final class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    private var next:String?
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
        print("Next url:\(next)")
    }
    
    public private(set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator:Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel])->Void) {
        //Fetch Locations
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
          return
         }
        
        isLoadingMoreResults = true
          
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllLocationsResponse.self) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.next = info.next  // Capture the next url if exists
                
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                
                var newResults:[RMLocationTableViewCellViewModel] = []
                switch self.results {
                case .locations(let existingResults):
                     newResults = existingResults + additionalLocations
                    self.results = .locations(newResults)
                case .episodes,.characters:
                    break
                }
             
                DispatchQueue.main.async {
                    self.isLoadingMoreResults = false
                    
                    //Notify via callback
                    completion(newResults)
                }
            case .failure(let error):
                self.isLoadingMoreResults = false
                print(error)
            }
        }
    }
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
}
