//
//  TasoPlayerListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 27/12/2017.
//

import Foundation
import ObjectMapper

struct TasoPlayerListing: Mappable {
    // MARK: - Properties
    
    var player: TasoPlayer!
    
    
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
