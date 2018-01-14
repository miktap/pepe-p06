//
//  TasoGroupListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 01/01/2018.
//

import Foundation
import ObjectMapper

struct TasoGroupListing: Mappable {
    // MARK: - Properties
    
    var group: TasoGroup?
    
    
    // MARK: - Mappable
    
    init?(map: Map) {
        if map.JSON["group"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        group <- map["group"]
    }
}
