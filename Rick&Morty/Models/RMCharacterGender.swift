//
//  RMCharacterGender.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 11/04/23.
//

import Foundation

enum RMCharacterGender:String,Codable {
    //'Female', 'Male', 'Genderless' or 'unknown'
    
    case female  = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}
