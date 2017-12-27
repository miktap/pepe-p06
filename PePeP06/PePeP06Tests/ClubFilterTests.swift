//
//  ClubFilterTests.swift
//  PePeP06Tests
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation
import Quick
import Nimble
@testable import PePeP06

class ClubFilterTests: QuickSpec {
    override func spec() {
        describe("ClubFilter") {
            var clubJSON = ""
            beforeEach {
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "Club", ofType: "json")!
                let url = URL(fileURLWithPath: path)
                clubJSON = 
            }
        }
    }
}
