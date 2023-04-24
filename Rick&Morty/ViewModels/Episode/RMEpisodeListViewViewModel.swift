//
//  RMEpisodeListViewViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 24/04/23.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate:AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths:[IndexPath])
    func didSelectEpisode(_ episode:RMEpisode)
}

/// ViewModel to handle episode list view logic
final class RMEpisodeListViewViewModel:NSObject {
    
    public weak var delegate:RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters:Bool = false
    
    private var borderColors:[UIColor] = [
        .systemCyan,
        .systemPurple,
        .systemPink,
        .systemIndigo,
        .systemOrange,
        .systemYellow,
        .systemRed,
        .systemGreen,
        .systemBrown
    ]
    
    private var episodes:[RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let cellViewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue)

                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var cellViewModels:[RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo:RMGetAllEpisodesResponse.Info? = nil
    
    /// Fetch initial set of episodes(20)
    public func fetchEpisodes() {
        RMService.shared.execute(.listEpisodeRequest, expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let episodes = responseModel.results
                let info = responseModel.info
                self?.apiInfo = info
                self?.episodes = episodes
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// paginate if additional episodes are needed
    public func fetchAdditionalEpisodes(url:URL) {
        //Fetch Characters
        guard !isLoadingMoreCharacters else {
            return
        }
        
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.apiInfo = info
                
                let originalCount = self.episodes.count
                //print("OriginalCount:\(originalCount)")
                let newCount = moreResults.count
               // print("NewCount:\(newCount)")
                let total = originalCount + newCount
                //print("Total:\(total)")
                let startingIndex = total-newCount
                let indexPathsToAdd:[IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
               // print("IndexpathsToadd:\(indexPathsToAdd)")
                self.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    self.isLoadingMoreCharacters = false
                }
                
            case .failure(let error):
                self.isLoadingMoreCharacters = false
                print(error)
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator:Bool {
        return   apiInfo?.next != nil
    }
}

//MARK: CollectionView
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter ,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError()
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width-20
        return CGSize(width: width,
                      height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

//MARK: ScrollView
extension RMEpisodeListViewViewModel:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
    //        print("Offset:\(offset)")
    //        print("totalContentHeight:\(totalContentHeight)")
    //        print("totalScrollViewFixedHeight:\(totalScrollViewFixedHeight)")
            
            if offset >= (totalContentHeight-totalScrollViewFixedHeight-120) {
               // print("should start fetching more")
                self?.fetchAdditionalEpisodes(url:url)
        }
            t.invalidate()
        }
    }
}
