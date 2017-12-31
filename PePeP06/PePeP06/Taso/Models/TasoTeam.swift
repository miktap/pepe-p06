//
//  TasoTeam.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Foundation
import ObjectMapper

struct TasoTeam: Mappable, Hashable {
    // MARK: - Properties
    
    var team_id: String!
    var team_name: String?
    var players: [TasoPlayer]?
    var categories: [TasoCategory]?
    
    var hashValue: Int {return team_id.hashValue}
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["team_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        team_id     <- map["team_id"]
        team_name   <- map["team_name"]
        players     <- map["players"]
        categories  <- map["categories"]
    }
    
    
    // MARK: - Equatable
    
    static func ==(lhs: TasoTeam, rhs: TasoTeam) -> Bool {
        return lhs.team_id == rhs.team_id
    }
}
