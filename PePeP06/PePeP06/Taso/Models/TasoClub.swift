//
//  TasoClub.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation
import ObjectMapper

struct TasoClub: Mappable {
    // MARK: - Properties
    
    var club_id: String!
    var name: String?
    var abbreviation: String?
    var teams: [TasoTeam]?
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["club_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        club_id         <- map["club_id"]
        name            <- map["name"]
        abbreviation    <- map["abbreviation"]
        teams           <- map["teams"]
    }
}
