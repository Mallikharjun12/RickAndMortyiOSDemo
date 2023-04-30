//
//  RMLocationView.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 30/04/23.
//

import UIKit

protocol RMLocationViewDelegate:AnyObject {
    func rmLocationView(_ locationView:RMLocationView, didSelect location: RMLocation)
}

final class RMLocationView:UIView {
    
    weak var delegate:RMLocationViewDelegate?
    
    private var viewModel :RMLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    private let tableView:UITableView = {
        let tbl = UITableView(frame: .zero, style: .grouped)
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbl.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        tbl.alpha = 0
        tbl.isHidden = true
        return tbl
    }()
    
    private let spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView,spinner)
        addConstraints()
        backgroundColor = .systemBackground
        spinner.startAnimating()
        configureTable()
    }
    
    
    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    public func configure(with viewModel :RMLocationViewViewModel) {
        self.viewModel = viewModel
    }
}


extension RMLocationView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Notify Controller with the selection
        guard let location = viewModel?.location(at: indexPath.row) else {
            return
        }
        
        delegate?.rmLocationView(self, didSelect: location)
    }
}

extension RMLocationView:UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else {
            fatalError()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}
