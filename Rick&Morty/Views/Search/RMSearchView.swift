//
//  RMSearchView.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 01/05/23.
//

import UIKit

protocol RMSearchViewDelegate:AnyObject {
    func rmSearchView(_ searchView:RMSearchView, didSelectOption option:RMSearchInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView:RMSearchView, didSelectLocation location:RMLocation)
}

final class RMSearchView: UIView {

    weak var delegate:RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    //MARK: Subviews
    
    //search input view(bar,selection buttons)
    private let searchInputView = RMSearchInputView()

    private let noResultsView = RMNoSearchResultsView()

    private let resultsView = RMSearchResultsView()
    //Results Collection View
    
    
    //MARK: Init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView,searchInputView,resultsView)
        addConstraints()
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        resultsView.delegate = self
       setUpHandlers(viewModel: viewModel)
    }
    
    private func setUpHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
           // print(tuple)
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        viewModel.registerSearchResultHandler {[weak self] result in
             // print(result)
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        viewModel.registerNoResultsHandler {[weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            //Input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            //ResultsView
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            //No Results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func presentKeyBoard() {
        searchInputView.presentKeyBoard()
    }
}

//MARK: CollectionView
extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: RMSearchInputViewDelegate
extension RMSearchView:RMSearchInputViewDelegate {
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewdidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

//MARK: RMSearchResultsViewDelegate
extension RMSearchView:RMSearchResultsViewDelegate {
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt Index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: Index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
}
