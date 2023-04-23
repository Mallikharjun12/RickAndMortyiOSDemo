//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 22/04/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    static let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        return formatter
    }()
    
    static let shortdateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let type:`Type`
    
    private let value:String
    
    public var title:String {
        return self.type.displayTitle
    }
    
    public var displayValue:String {
        if value.isEmpty {return "None"}
        
        if  type == .created,let date = Self.dateFormatter.date(from: value) {
            return Self.shortdateFormatter.string(from: date)
        }
        return value
    }
    
    public var iconImage:UIImage? {
        return type.icon
    }
    
    public var tintColor:UIColor {
        return type.tintColor
    }
    
    enum `Type`:String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        
        var tintColor:UIColor {
            switch self {
            case .status:
                return .systemPurple
            case .gender:
                return .systemGreen
            case .type:
                return .systemYellow
            case .species:
                return .systemMint
            case .origin:
                return .systemCyan
            case .location:
                return .systemOrange
            case .created:
                return .systemPink
            case .episodeCount:
                return .systemTeal
            }
        }
        
        var icon:UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle:String {
            switch self {
            case .status:
                return rawValue.uppercased()
            case .gender:
                return rawValue.uppercased()
            case .type:
                return rawValue.uppercased()
            case .species:
                return rawValue.uppercased()
            case .origin:
                return rawValue.uppercased()
            case .location:
                return rawValue.uppercased()
            case .created:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }
    
    
    init(type:`Type` ,value:String) {
        self.value = value
        self.type = type
    }
    
}
