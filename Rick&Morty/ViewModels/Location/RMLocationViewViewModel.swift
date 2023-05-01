//
//  RMLocationViewViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 30/04/23.
//

import Foundation

protocol RMLocationViewViewModelDelegate:AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    public var isLoadingMoreLocations = false
    
    public weak var delegate:RMLocationViewViewModelDelegate?
    
    private var locations:[RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    public private(set) var cellViewModels:[RMLocationTableViewCellViewModel] = []
    
    private var apiInfo:RMGetAllLocationsResponse.Info?
    
    public var shouldShowLoadMoreIndicator:Bool {
        return apiInfo?.next != nil
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < self.locations.count,index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    
    private var didFinishPagination:(()->())?
    
    
    
    //MARK: init
    init() {
        
    }
    
    public func registerDidFinishPagination(_ block: @escaping (()->())) {
        self.didFinishPagination = block
    }
    
    /// paginate if additional Locations are needed
    public func fetchAdditionalLocations() {
        //Fetch Locations
        guard !isLoadingMoreLocations else {
            return
        }
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
          return
         }
        
        isLoadingMoreLocations = true
          
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
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
                self.apiInfo = info
                self.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                }))
             
                DispatchQueue.main.async {
                    self.isLoadingMoreLocations = false
                    self.didFinishPagination?()
                }
            case .failure(let error):
                self.isLoadingMoreLocations = false
                print(error)
            }
        }
    }
    
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: RMGetAllLocationsResponse.self) { [weak self]result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    private var hasMoreResults:Bool {
        return false
    }
}
