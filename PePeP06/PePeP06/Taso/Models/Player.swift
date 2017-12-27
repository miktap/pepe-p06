//
//  Player.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Foundation
import ObjectMapper

struct Player: Mappable {
    // MARK: - Properties
    
    var player_id: String!
    var first_name: String?
    var last_name: String?
    var shirt_number: String?
    var matches: String?
    var goals: String?
    var assists: String?
    var warnings: String?
    var suspensions: String?
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["player_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        player_id       <- map["player_id"]
        first_name      <- map["first_name"]
        last_name       <- map["last_name"]
        shirt_number    <- map["shirt_number"]
        matches         <- map["matches"]
        goals           <- map["goals"]
        assists         <- map["assists"]
        warnings        <- map["warnings"]
        suspensions     <- map["suspensions"]
    }
}
