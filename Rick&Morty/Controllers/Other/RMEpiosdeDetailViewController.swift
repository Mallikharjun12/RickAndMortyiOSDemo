//
//  RMEpiosdeDetailViewController.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 23/04/23.
//

import UIKit

/// VC to show information about a single Episode
final class RMEpiosdeDetailViewController: UIViewController {

    private let viewModel:RMEpisodeDetailViewViewModel
    
    private let detailView = RMEpisodeDetailView()
    
    //MARK: Init
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewViewModel(endPointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        setUpView()
    }
    
    @objc private func didTapShare() {
        //share episode info
    }
    
    private func setUpView() {
         view.addSubview(detailView)
         NSLayoutConstraint.activate([
             detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
     }
}
