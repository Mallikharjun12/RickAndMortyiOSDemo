//
//  RMCharacterListViewViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 12/04/23.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate:AnyObject {
    func didLoadInitialCharacters()
}

class RMCharacterListViewViewModel:NSObject {
    
    public weak var delegate:RMCharacterListViewViewModelDelegate?
    
    private var characters:[RMCharacter] = [] {
        didSet {
            for character in characters {
                let cellViewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                cellViewModels.append(cellViewModel)
            }
        }
    }
    
    private var cellViewModels:[RMCharacterCollectionViewCellViewModel] = []
    
    func fetchCharacters() {
        RMService.shared.execute(.listCharacterRequests, expecting: RMGetAllCharactersResponse.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let characters = responseModel.results
                self?.characters = characters
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width,
                      height: width*1.5)
    }
}
