//
//  TeamListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Foundation
import ObjectMapper

struct TeamListing: Mappable {
    // MARK: - Properties
    
    var team: Team!
    
    
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

