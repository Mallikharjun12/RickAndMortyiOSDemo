//
//  RMCharacterListViewViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 12/04/23.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate:AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths:[IndexPath])
    func didSelectCharacter(_ character:RMCharacter)
}

/// ViewModel to handle character list view logic
final class RMCharacterListViewViewModel:NSObject {
    
    public weak var delegate:RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters:Bool = false
    
    private var characters:[RMCharacter] = [] {
        didSet {
            for character in characters {
                let cellViewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var cellViewModels:[RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo:RMGetAllCharactersResponse.Info? = nil
    
    /// Fetch initial set of characters(20)
    public func fetchCharacters() {
        RMService.shared.execute(.listCharacterRequests, expecting: RMGetAllCharactersResponse.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let characters = responseModel.results
                let info = responseModel.info
                self?.apiInfo = info
                self?.characters = characters
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// paginate if additional characters are needed
    public func fetchAdditionalCharacters(url:URL) {
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
                                 expecting: RMGetAllCharactersResponse.self) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.apiInfo = info
                
                let originalCount = self.characters.count
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
                self.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
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
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else {
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
        let width:CGFloat
        if UIDevice.isiphone {
           width = (bounds.width-30)/2
        } else {
            width = (bounds.width-50)/4
        }
        return CGSize(width: width,
                      height: width*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

//MARK: ScrollView
extension RMCharacterListViewViewModel:UIScrollViewDelegate {
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
                self?.fetchAdditionalCharacters(url:url)
        }
            t.invalidate()
        }
    }
}
