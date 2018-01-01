//
//  TasoPlayer.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Foundation
import ObjectMapper

struct TasoPlayer: Mappable, Hashable {
    // MARK: - Properties
    
    var player_id: String!
    var player_name: String?
    var first_name: String?
    var last_name: String?
    var shirt_number: String?
    var matches: String?
    var goals: String?
    var assists: String?
    var warnings: String?
    var suspensions: String?

    var hashValue: Int {return player_id.hashValue}

    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["player_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        player_id       <- map["player_id"]
        player_name     <- map["player_name"]
        first_name      <- map["first_name"]
        last_name       <- map["last_name"]
        shirt_number    <- map["shirt_number"]
        matches         <- map["matches"]
        goals           <- map["goals"]
        assists         <- map["assists"]
        warnings        <- map["warnings"]
        suspensions     <- map["suspensions"]
    }
    
    
    // MARK: - Equatable
    
    static func ==(lhs: TasoPlayer, rhs: TasoPlayer) -> Bool {
        return lhs.player_id == rhs.player_id
    }
}
