//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 22/04/23.
//

import UIKit

protocol RMEpisodeDataRender {
    var name:String { get }
    var air_date:String { get }
    var episode:String { get }
    
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    
    private let episodeDataUrl:URL?
    private var isFetching = false
    
    private var dataBlock:((RMEpisodeDataRender)->())?
    
    public var borderColor:UIColor
    
    private var episode:RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            self.dataBlock?(model)
        }
    }
    
    //MARK: Init
    init(episodeDataUrl:URL?,borderColor:UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    //MARK: Public
    public func registerForData(_ block: @escaping (RMEpisodeDataRender)->()) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url) else {
            return
        }
        isFetching = true
        RMService.shared.execute(request, expecting: RMEpisode.self) {[weak self] result in
            switch result {
            case .success(let episode):
                DispatchQueue.main.async {
                    self?.episode = episode
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
