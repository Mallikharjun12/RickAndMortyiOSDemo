//
//  RMLocationDetailViewController.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 30/04/23.
//

import UIKit

final class RMLocationDetailViewController: UIViewController , RMLocationDetailViewViewModelDelegate, RMLocationDetailViewDelegate {
    
    private let viewModel:RMLocationDetailViewViewModel
    
    private let detailView = Rick_Morty.RMLocationDetailView()
    
    //MARK: Init
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endPointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        setUpView()
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }
    
    @objc private func didTapShare() {
        //share episode info
    }
    
    private func setUpView() {
         view.addSubview(detailView)
        detailView.delegate = self
         NSLayoutConstraint.activate([
             detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
     }
    
    
    //MARK: Delegate
    
    
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
    
    func RMLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        detailVC.title = character.name
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
