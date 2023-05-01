//
//  RMLocationDetailViewViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 01/05/23.
//

import UIKit

protocol RMLocationDetailViewViewModelDelegate:AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel{

    private let endPointUrl:URL?
    private var dataTuple:(location:RMLocation, characters:[RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels:[RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModels:[RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate:RMLocationDetailViewViewModelDelegate?
    
    
    public private(set) var cellViewModels:[SectionType] = []
    
    //MARK: Init
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
    }
    
    public func character(at index:Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    
    //MARK: Private
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdString = location.created
        
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: createdString) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortdateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(value: location.name, title: "Location Name"),
                .init(value: location.type, title: "Type"),
                .init(value: location.dimension, title: "Dimension"),
                .init(value: createdString, title: "Created")
            ]),
            .character(viewModels: characters.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
        ]
    }
    
    
    /// Fetch characters in a Location
    public func fetchLocationData() {
        guard let url = endPointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMLocation.self) {[weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(for: model)
            case .failure(let error):
                print(String(describing: error.localizedDescription))
            }
        }
    }
    
    private func fetchRelatedCharacters(for location: RMLocation) {
        let requests:[RMRequest] = location.residents.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters:[RMCharacter] = []
        
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (
                location:location,
                characters:characters
            )
        }
    }
}
