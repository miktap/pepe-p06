//
//  TasoMatch.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 02/01/2018.
//

import Foundation
import ObjectMapper

struct TasoMatch: Mappable {
    // MARK: - Properties
    
    var match_id: String!
    var season_id: String?
    var competition_id: String?
    var competition_name: String?
    var category_id: String?
    var category_name: String?
    var group_id: String?
    var group_name: String?
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["match_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        match_id            <- map["match_id"]
        season_id           <- map["season_id"]
        competition_id      <- map["competition_id"]
        competition_name    <- map["competition_name"]
        category_id         <- map["category_id"]
        category_name       <- map["category_name"]
        group_id            <- map["group_id"]
        group_name          <- map["group_name"]
    }
}
