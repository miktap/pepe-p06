//
//  TasoGroup.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 01/01/2018.
//

import Foundation
import ObjectMapper

struct TasoGroup: Mappable, CustomStringConvertible {
    // MARK: - Properties
    
    var competition_id: String!
    var competition_name: String?
    var season_id: String?
    var category_id: String!
    var category_name: String?
    var group_id: String!
    var group_name: String?
    var player_statistics: [TasoPlayer]?
    var teams: [TasoTeam]?
    
    var description: String {return "\(competition_id)/\(category_id)/\(group_id)"}
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["competition_id"] == nil ||
            map.JSON["category_id"] == nil ||
            map.JSON["group_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        competition_id      <- map["competition_id"]
        competition_name    <- map["competition_name"]
        season_id           <- map["season_id"]
        category_id         <- map["category_id"]
        group_id            <- map["group_id"]
        group_name          <- map["group_name"]
        player_statistics   <- map["player_statistics"]
        teams               <- map["teams"]
    }
}
