//
//  DataServiceTests.swift
//  PePeP06Tests
//
//  Created by Mikko Tapaninen on 28/12/2017.
//

import Foundation
import Quick
import Nimble
@testable import PePeP06

class DataServiceTests: QuickSpec {
    override func spec() {
        describe("DataService") {
            var dataService: DataService!
            var mockTasoClient: MockTasoClient!
            var mockDelegate: MockDataServiceDelegate!
            
            beforeEach {
                mockTasoClient = MockTasoClient()
                mockDelegate = MockDataServiceDelegate()
                
                dataService = DataService(client: mockTasoClient)
                dataService.addDelegate(delegate: mockDelegate)
            }
            
            describe("populateClub") {
                context("when promise rejects") {
                    it("notifies delegates with an error") {
                        mockTasoClient.rejectPromise = true
                        
                        dataService.populateClub()
                        
                        expect(mockDelegate.clubPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.clubPopulatedClub).toEventually(beNil())
                        expect(mockDelegate.clubPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response has no data") {
                    it("notifies delegates with an error") {
                        mockTasoClient.webResponse = WebResponse(data: nil, statusCode: 200)
                        
                        dataService.populateClub()
                        
                        expect(mockDelegate.clubPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.clubPopulatedClub).toEventually(beNil())
                        expect(mockDelegate.clubPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response cannot be parsed to 'ClubListing'") {
                    it("notifies delegates with an error") {
                        let json = """
{
    "club": {
        "name": "PERTTELIN PEIKOT",
        "abbrevation": "PePe"
    }
}

"""
                        mockTasoClient.webResponse = WebResponse(data: json.data(using: .utf8)!, statusCode: 200)
                        
                        dataService.populateClub()
                        
                        expect(mockDelegate.clubPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.clubPopulatedClub).toEventually(beNil())
                        expect(mockDelegate.clubPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response is valid") {
                    it("notifies delegates with categories") {
                        let bundle = Bundle(for: type(of: self))
                        let path = bundle.path(forResource: "Club", ofType: "json")!
                        let url = URL(fileURLWithPath: path)
                        let clubJSON = try! String(contentsOf: url, encoding: .utf8)
                        mockTasoClient.webResponse = WebResponse(data: clubJSON.data(using: .utf8)!, statusCode: 200)
                        
                        dataService.populateClub()
                        
                        expect(mockDelegate.clubPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.clubPopulatedClub?.club_id).toEventually(equal("3077"))
                        expect(mockDelegate.clubPopulatedError).toEventually(beNil())
                    }
                }
            }
            
            describe("populateTeams") {
                context("when promise rejects") {
                    it("notifies delegates with an error") {
                        mockTasoClient.rejectPromise = true
                        
                        dataService.populateTeams(team_ids: ["1","2"])
                        
                        expect(mockDelegate.teamsPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamsPopulatedTeams).toEventually(beNil())
                        expect(mockDelegate.teamsPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response has no data") {
                    it("notifies delegates with an error") {
                        mockTasoClient.webResponse = WebResponse(data: nil, statusCode: 200)
                        
                        dataService.populateTeams(team_ids: ["1","2"])
                        
                        expect(mockDelegate.teamsPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamsPopulatedTeams).toEventually(beNil())
                        expect(mockDelegate.teamsPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response cannot be parsed to 'TeamListing'") {
                    it("notifies delegates with an error") {
                        let json = """
{
    "team": {
        "team_name": "pepe"
    }
}

"""
                        mockTasoClient.webResponse = WebResponse(data: json.data(using: .utf8)!, statusCode: 200)
                        
                        dataService.populateTeams(team_ids: ["1","2"])
                        
                        expect(mockDelegate.teamsPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamsPopulatedTeams).toEventually(beNil())
                        expect(mockDelegate.teamsPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response is valid") {
                    it("notifies delegates with categories") {
                        let bundle = Bundle(for: type(of: self))
                        let path = bundle.path(forResource: "Team", ofType: "json")!
                        let url = URL(fileURLWithPath: path)
                        let teamJSON = try! String(contentsOf: url, encoding: .utf8)
                        mockTasoClient.webResponse = WebResponse(data: teamJSON.data(using: .utf8)!, statusCode: 200)
                        
                        dataService.populateTeams(team_ids: ["1","2"])
                        
                        expect(mockDelegate.teamsPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamsPopulatedTeams?.count).toEventually(equal(2))
                        expect(mockDelegate.teamsPopulatedError).toEventually(beNil())
                    }
                }
            }
            
            describe("populateTeamWithCategory") {
                context("when promise rejects") {
                    it("notifies delegates with an error") {
                        mockTasoClient.rejectPromise = true
                        
                        dataService.populateTeamWithCategory(team_id: "1", category_id: "2")
                        
                        expect(mockDelegate.teamWithCategoryPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamWithCategoryPopulatedTeam).toEventually(beNil())
                        expect(mockDelegate.teamWithCategoryPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response has no data") {
                    it("notifies delegates with an error") {
                        mockTasoClient.webResponse = WebResponse(data: nil, statusCode: 200)
                        
                        dataService.populateTeamWithCategory(team_id: "1", category_id: "2")
                        
                        expect(mockDelegate.teamWithCategoryPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamWithCategoryPopulatedTeam).toEventually(beNil())
                        expect(mockDelegate.teamWithCategoryPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response cannot be parsed to 'TeamListing'") {
                    it("notifies delegates with an error") {
                        let json = """
{
    "team": {
        "team_name": "pepe"
    }
}

"""
                        mockTasoClient.webResponse = WebResponse(data: json.data(using: .utf8)!, statusCode: 200)
                        
                        dataService.populateTeamWithCategory(team_id: "1", category_id: "2")
                        
                        expect(mockDelegate.teamWithCategoryPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamWithCategoryPopulatedTeam).toEventually(beNil())
                        expect(mockDelegate.teamWithCategoryPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response is valid") {
                    it("notifies delegates with team") {
                        let bundle = Bundle(for: type(of: self))
                        let path = bundle.path(forResource: "Team", ofType: "json")!
                        let url = URL(fileURLWithPath: path)
                        let teamJSON = try! String(contentsOf: url, encoding: .utf8)
                        mockTasoClient.webResponse = WebResponse(data: teamJSON.data(using: .utf8)!, statusCode: 200)
                        
                        dataService.populateTeamWithCategory(team_id: "1", category_id: "2")
                        
                        expect(mockDelegate.teamWithCategoryPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.teamWithCategoryPopulatedTeam?.team_id).toEventually(equal("141460"))
                        expect(mockDelegate.teamWithCategoryPopulatedError).toEventually(beNil())
                    }
                }
            }
        }
    }
}

class MockDataServiceDelegate: DataServiceDelegate {
    var id: String = "MockDataServiceDelegate"
    
    var clubPopulatedCalled = false
    var clubPopulatedClub: TasoClub?
    var clubPopulatedError: Error?
    
    var teamsPopulatedCalled = false
    var teamsPopulatedTeams: [TasoTeam]?
    var teamsPopulatedError: Error?
    
    var teamWithCategoryPopulatedCalled = false
    var teamWithCategoryPopulatedTeam: TasoTeam?
    var teamWithCategoryPopulatedError: Error?
    
    func clubPopulated(club: TasoClub?, error: Error?) {
        clubPopulatedCalled = true
        clubPopulatedClub = club
        clubPopulatedError = error
    }
    
    func teamsPopulated(teams: [TasoTeam]?, error: Error?) {
        teamsPopulatedCalled = true
        teamsPopulatedTeams = teams
        teamsPopulatedError = error
    }
    
    func teamWithCategoryPopulated(team: TasoTeam?, error: Error?) {
        teamWithCategoryPopulatedCalled = true
        teamWithCategoryPopulatedTeam = team
        teamWithCategoryPopulatedError = error
    }
}

