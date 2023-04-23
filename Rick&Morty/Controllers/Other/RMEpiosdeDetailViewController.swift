//
//  RMEpiosdeDetailViewController.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 23/04/23.
//

import UIKit

/// VC to show information about a single Episode
final class RMEpiosdeDetailViewController: UIViewController {

    private var url:URL?
    
    //MARK: Init
    init(url: URL?) {
        self.url = url
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
    }
}
