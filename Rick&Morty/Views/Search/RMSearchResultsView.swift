//
//  RMSearchResultsView.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 07/05/23.
//

import UIKit

protocol RMSearchResultsViewDelegate:AnyObject {
    func rmSearchResultsView(_ resultsView:RMSearchResultsView,didTapLocationAt Index:Int)
}

/// shows the searchResults UI  (TableView or collectionView as needed)
final class RMSearchResultsView: UIView {

    weak var delegate:RMSearchResultsViewDelegate?
    
    private var viewModel:RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private var locationCellViewModels:[RMLocationTableViewCellViewModel] = []
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel {
        case .characters(let viewModels):
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        case .episodes(let viewModels):
            setUpCollectionView()
        }
    }
    
    private func setUpCollectionView() {
        
    }
    
    private func setUpTableView(viewModels:[RMLocationTableViewCellViewModel]) {
        self.locationCellViewModels = viewModels
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(with viewModel:RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}


extension RMSearchResultsView:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}
