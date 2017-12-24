//
//  TasoClientTests.swift
//  PePeP06Tests
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Quick
import Nimble
import ObjectMapper
@testable import PePeP06

class TasoClientTests: QuickSpec {
    override func spec() {
        describe("Taso") {
            var tasoClient: TasoClient!
            
            beforeEach {
                tasoClient = TasoClient()
            }
            
            describe("getTeam") {
                it("gets PePe team") {
                    var teamListing: TeamListing?
                    tasoClient.getTeam(id: 141460)!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            teamListing = TeamListing(JSONString: message!)
                    }
                    
                    expect(teamListing?.team.team_name).toEventually(equal("PePe"))
                }
            }
        }
    }
}
