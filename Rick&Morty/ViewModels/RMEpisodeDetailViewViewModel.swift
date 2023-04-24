//
//  RMEpisodeDetailViewVIewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 23/04/23.
//

import UIKit

final class RMEpisodeDetailViewViewModel{

    private let endPointUrl:URL?
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
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
        let characterUrls:[URL] = episode.characters.compactMap({
            return URL(string: $0)
        })
        
        
    }
}
