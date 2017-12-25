//
//  CompetitionListing.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 25/12/2017.
//

import Foundation
import ObjectMapper

struct CompetitionListing: Mappable {
    // MARK: - Properties
    
    var competitions: [Competition]?

    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        competitions <- map["competitions"]
    }
}
