//
//  RMGetAllEpisodesResponse.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 24/04/23.
//

import Foundation

struct RMGetAllEpisodesResponse:Codable {
    let info:Info
    let results:[RMEpisode]
    
    struct Info:Codable {
        let count:Int
        let pages:Int
        let next:String?
        let prev:String?
    }
    
}
