//
//  TasoCategoryListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation
import ObjectMapper

struct TasoCategoryListing: Mappable {
    // MARK: - Properties
    
    var categories: [TasoCategory]?
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["categories"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        categories <- map["categories"]
    }
}
