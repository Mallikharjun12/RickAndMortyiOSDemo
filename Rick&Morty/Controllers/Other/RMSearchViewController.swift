//
//  RMSearchViewController.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 24/04/23.
//

import UIKit

/// Configurable Controller to search
final class RMSearchViewController: UIViewController {

    struct Config {
        enum `Type` {
            case character
            case episode
            case location
        }
        let type:`Type`
    }
    
    private let config:Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
    }
}
