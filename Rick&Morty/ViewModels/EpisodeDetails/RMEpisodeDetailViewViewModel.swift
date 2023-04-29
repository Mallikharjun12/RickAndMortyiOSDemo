//
//  RMEpisodeDetailViewVIewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 23/04/23.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate:AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel{

    private let endPointUrl:URL?
    private var dataTuple:(episode:RMEpisode, characters:[RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels:[RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModels:[RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate:RMEpisodeDetailViewViewModelDelegate?
    
    
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
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: createdString) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortdateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(value: episode.name, title: "Episode Name"),
                .init(value: episode.air_date, title: "Air Date"),
                .init(value: episode.episode, title: "Episode"),
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
    
    
    /// Fetch characters in a episode
    public func fetchEpisodeData() {
        guard let url = endPointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) {[weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(for: model)
            case .failure(let error):
                print(String(describing: error.localizedDescription))
            }
        }
    }
    
    private func fetchRelatedCharacters(for episode: RMEpisode) {
        let requests:[RMRequest] = episode.characters.compactMap({
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
                episode:episode,
                characters:characters
            )
        }
    }
}
