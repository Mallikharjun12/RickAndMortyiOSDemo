//
//  RMCharacterDetailViewController.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 16/04/23.
//

import UIKit

/// Controller to show info about a single character
final class RMCharacterDetailViewController: UIViewController {

    private let viewModel:RMCharacterDetailViewViewModel
    
    private let detailView:RMCharacterDetailView
    
    //MARK: Init
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        addConstraints()
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }

    @objc private func didTapShare() {
        //share character info
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: CollectionView

extension RMCharacterDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 7
        case 2:
            return 20
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        switch viewModel.sections[indexPath.section] {
            
        case .photo:
            cell.backgroundColor = .systemRed
        case .information:
            cell.backgroundColor = .systemGreen
        case .episode:
            cell.backgroundColor = .systemPurple
        }
        return cell
    }
}
