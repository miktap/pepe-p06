//
//  PlayerListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 27/12/2017.
//

import Foundation
import ObjectMapper

struct PlayerListing: Mappable {
    // MARK: - Properties
    
    var player: Player!
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["player"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        player <- map["player"]
    }
}
