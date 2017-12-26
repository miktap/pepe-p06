//
//  TasoClientTests.swift
//  PePeP06Tests
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Quick
import Nimble
import ObjectMapper
import SwiftyBeaver
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
                    tasoClient.getTeam(team_id: "141460")!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            teamListing = TeamListing(JSONString: message!)
                    }
                    
                    expect(teamListing?.team.team_name).toEventually(equal("PePe"))
                }
            }
            
            describe("getCompetitions") {
                it("gets lsfs1718 competition") {
                    var competitionListing: CompetitionListing?
                    tasoClient.getCompetitions()!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            competitionListing = CompetitionListing(JSONString: message!)
                    }
                    
                    expect(competitionListing?.competitions!).toEventually(containElementSatisfying({$0.competition_id == "lsfs1718"}), timeout: 3)
                }
            }
            
            describe("getCategories") {
                it("gets") {
                    var result = false
                    tasoClient.getCategories(competition_id: "lsfs1718")!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            result = true
                    }
                    
                    expect(result).toEventually(beTrue())
                }
            }
        }
    }
}
