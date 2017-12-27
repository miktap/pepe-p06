//
//  Competition.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 25/12/2017.
//

import Foundation
import ObjectMapper

struct Competition: Mappable {
    // MARK: - Properties
    
    var competition_id: String!
    var competition_name: String?
    var competition_status: String?
    var season_id: String?
    var organiser: String?
    var organiser_name: String?
    var sport_id: String?
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["competition_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        competition_id      <- map["competition_id"]
        competition_name    <- map["competition_name"]
        competition_status  <- map["competition_status"]
        season_id           <- map["season_id"]
        organiser           <- map["organiser"]
        organiser_name      <- map["organiser_name"]
        sport_id            <- map["sport_id"]
    }
}
