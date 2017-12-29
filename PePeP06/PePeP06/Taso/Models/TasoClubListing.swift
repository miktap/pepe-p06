//
//  TasoClubListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation
import ObjectMapper

struct TasoClubListing: Mappable {
    // MARK: - Properties
    
    var club: TasoClub?
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["club"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        club <- map["club"]
    }
}
