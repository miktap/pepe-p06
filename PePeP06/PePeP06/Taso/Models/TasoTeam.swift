//
//  TasoTeam.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Foundation
import ObjectMapper

struct TasoTeam: Mappable, Hashable, CustomStringConvertible {
    // MARK: - Properties
    
    var team_id: String!
    var team_name: String?
    var players: [TasoPlayer]?
    var categories: [TasoCategory]?
    var current_standing: String?
    var points: String?
    var matches_played: String?
    var matches_won: String?
    var matches_tied: String?
    var matches_lost: String?
    var goals_for: String?
    var goals_against: String?
    
    var hashValue: Int {return team_id.hashValue}
    var description: String {return "\(team_id!)/\(team_name ?? "")"}

    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["team_id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        team_id             <- map["team_id"]
        team_name           <- map["team_name"]
        players             <- map["players"]
        categories          <- map["categories"]
        current_standing    <- map["current_standing"]
        points              <- map["points"]
        matches_played      <- map["matches_played"]
        matches_won         <- map["matches_won"]
        matches_tied        <- map["matches_tied"]
        matches_lost        <- map["matches_lost"]
        goals_for           <- map["goals_for"]
        goals_against       <- map["goals_against"]
    }
    
    
    // MARK: - Equatable
    
    static func ==(lhs: TasoTeam, rhs: TasoTeam) -> Bool {
        return lhs.team_id == rhs.team_id
    }
}
