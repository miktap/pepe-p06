//
//  TasoTeamListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Foundation
import ObjectMapper

struct TasoTeamListing: Mappable {
    // MARK: - Properties
    
    var team: TasoTeam!
    
    
    // MARK: - MappableFoundation
    
    init?(map: Map) {
        if map.JSON["team"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        team <- map["team"]
    }
}

