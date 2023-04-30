//
//  RMSettingsViewController.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 11/04/23.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

/// Controller to show various app Options And Settings
final class RMSettingsViewController: UIViewController {

    
    private var settingsSwiftUIController:UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        addSwiftUIController()
    }


    private func addSwiftUIController() {
        
        let settingsSwiftUIController = UIHostingController(
            rootView: RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({
                return RMSettingsCellViewModel(type: $0) {[weak self] option in
                    self?.handleTap(option: option)
                }
            })))
        )
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handleTap(option:RMSettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }
        if let url = option.targetUrl {
            //open website
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            //show rating prompt
            if let windowScene = self.view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
