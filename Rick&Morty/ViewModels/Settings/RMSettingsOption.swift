//
//  RMSettingsOption.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 29/04/23.
//

import UIKit

enum RMSettingsOption:CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targetUrl:URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://iosacademy.io")
        case .terms:
            return URL(string: "https://iosacademy.io/terms")
        case .privacy:
            return URL(string: "https://iosacademy.io/privacy")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/playlist?list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y")
        case .viewCode:
            return URL(string: "https://github.com/Mallikharjun12/RickAndMortyiOSDemo")
        }
    }
    
    var displayTitle:String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms Of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconImage:UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    var iconContainerColor:UIColor {
        switch self {
        case .rateApp:
            return .systemRed
        case .contactUs:
            return .systemOrange
        case .terms:
            return .systemPurple
        case .privacy:
            return .systemMint
        case .apiReference:
            return .systemPink
        case .viewSeries:
            return .systemYellow
        case .viewCode:
            return .systemGreen
        }
    }
}
