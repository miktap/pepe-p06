//
//  TasoCategory.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation
import ObjectMapper

struct TasoCategory: Mappable, Hashable, CustomStringConvertible {
    // MARK: - Properties
    
    var category_id: String!
    var category_name: String?
    var category_team_name: String?
    var competition_id: String!
    var competition_name: String?
    var competition_season: String?
    var competition_active: String?
    
    var hashValue: Int {return category_id.hashValue}
    var description: String {return "\(category_id!)/\(competition_id!)"}
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["category_id"] == nil ||
            map.JSON["competition_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        category_id         <- map["category_id"]
        category_name       <- map["category_name"]
        category_team_name  <- map["category_team_name"]
        competition_id      <- map["competition_id"]
        competition_name    <- map["competition_name"]
        competition_season  <- map["competition_season"]
        competition_active  <- map["competition_active"]
    }
    
    
    // MARK: - Equatable
    
    static func ==(lhs: TasoCategory, rhs: TasoCategory) -> Bool {
        return lhs.category_id == rhs.category_id &&
            lhs.competition_id == rhs.competition_id
    }
}
