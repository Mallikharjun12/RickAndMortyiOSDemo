//
//  RMLocationTableViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 30/04/23.
//

import Foundation

final class RMLocationTableViewCellViewModel: Hashable, Equatable {
    
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    public var name:String {
        return location.name
    }
    
    public var type:String {
        return location.type
    }
    
    public var dimension:String {
        return location.dimension
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
    }
}
