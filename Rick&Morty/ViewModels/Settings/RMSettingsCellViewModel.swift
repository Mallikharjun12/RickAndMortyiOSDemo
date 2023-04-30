//
//  RMSettingsCellViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 29/04/23.
//

import UIKit

struct RMSettingsCellViewModel:Identifiable {
    
    let id = UUID()
    
    public let type:RMSettingsOption
    
    public var onTapHandler:((RMSettingsOption)->Void)
    
    //MARK: Init
    init(type:RMSettingsOption, onTapHandler: @escaping (RMSettingsOption)->Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    //MARK: Public
    public var image:UIImage? {
        return type.iconImage
    }
    public var title:String {
        return type.displayTitle
    }
    
    public var iconContainerColor:UIColor {
        return type.iconContainerColor
    }
}
