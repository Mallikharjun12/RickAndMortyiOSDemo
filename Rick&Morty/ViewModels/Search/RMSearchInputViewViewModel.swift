//
//  RMSearchInputViewViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 04/05/23.
//

import Foundation

final class RMSearchInputViewViewModel {
    
    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicOption:String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var choices:[String] {
            switch self {
            case .status:
               return ["alive","dead","unknown"]
            case .gender:
               return ["male","female","genderless", "unknown"]
            case .locationType:
               return ["Planet","Dimension","Microverse","TV","Resort"]
            }
        }
    }
    
    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }
    
    //MARK: public
    
//case character // name | status | gender
//case episode // name
//case location //name | type

    
    public var hasDynamicOptions:Bool {
        switch self.type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }
    
    public var options:[DynamicOption] {
        switch self.type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    
    public var searchPlaceholderText:String {
        switch self.type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Name"
        }
    }
}
