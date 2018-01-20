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
                tasoClient.initialize()
                sleep(1)
            }
            
            describe("getTeam") {
                it("gets PePe team") {
                    var teamListing: TasoTeamListing?
                    tasoClient.getTeam(team_id: "141460", competition_id: "lsfs1718", category_id: "FP12")!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            teamListing = TasoTeamListing(JSONString: message!)
                    }
                    
                    expect(teamListing?.team.team_name).toEventually(equal("PePe"), timeout: 3)
                }
            }
            
            describe("getCompetitions") {
                it("gets lsfs1718 competition") {
                    var competitionListing: TasoCompetitionListing?
                    tasoClient.getCompetitions()!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            competitionListing = TasoCompetitionListing(JSONString: message!)
                    }
                    
                    expect(competitionListing?.competitions!).toEventually(containElementSatisfying({$0.competition_id == "lsfs1718"}), timeout: 3)
                }
            }
            
            describe("getCategories") {
                it("gets category FP12") {
                    var categoryListing: TasoCategoryListing?
                    tasoClient.getCategories(competition_id: "lsfs1718")!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            categoryListing = TasoCategoryListing(JSONString: message!)
                    }
                    
                    expect(categoryListing?.categories).toEventually(containElementSatisfying({$0.category_id == "FP12"}), timeout: 3)
                }
            }
            
            describe("getClub") {
                it("gets club 3077") {
                    var clubListing: TasoClubListing?
                    tasoClient.getClub()!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            clubListing = TasoClubListing(JSONString: message!)
                    }
                    
                    expect(clubListing?.club?.club_id).toEventually(equal("3077"), timeout: 3)
                }
            }
            
            describe("getPlayer") {
                it("gets player Jimi") {
                    var playerListing: TasoPlayerListing?
                    tasoClient.getPlayer(player_id: "290384")!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            playerListing = TasoPlayerListing(JSONString: message!)
                    }
                    
                    expect(playerListing?.player?.first_name).toEventually(equal("Jimi"), timeout: 3)
                }
            }
            
            describe("getGroup") {
                it("gets group with team standings") {
                    var groupListing: TasoGroupListing?
                    tasoClient.getGroup(competition_id: "lsfs1718", category_id: "FP12", group_id: "1")!
                        .then { response -> Void in
                            let message = String(data: response.data!, encoding: .utf8)
                            log.debug(message!)
                            groupListing = TasoGroupListing(JSONString: message!)
                    }
                    
                    expect(groupListing?.group?.teams).toNotEventually(beNil(), timeout: 3)
                }
            }
        }
    }
}
