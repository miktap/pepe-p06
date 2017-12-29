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
            
            describe("populateCategories") {
                context("when promise rejects") {
                    it("notifies delegates with an error") {
                        mockTasoClient.rejectPromise = true
                        
                        dataService.populateCategories()
                        
                        expect(mockDelegate.categoriesPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.categoriesPopulatedCategories).toEventually(beNil())
                        expect(mockDelegate.categoriesPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response has no data") {
                    it("notifies delegates with an error") {
                        mockTasoClient.webResponse = WebResponse(data: nil, statusCode: 200)
                        
                        dataService.populateCategories()
                        
                        expect(mockDelegate.categoriesPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.categoriesPopulatedCategories).toEventually(beNil())
                        expect(mockDelegate.categoriesPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
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
                        
                        dataService.populateCategories()
                        
                        expect(mockDelegate.categoriesPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.categoriesPopulatedCategories).toEventually(beNil())
                        expect(mockDelegate.categoriesPopulatedError).toEventually(beAnInstanceOf(DataServiceError.self))
                    }
                }
                
                context("when response is valid") {
                    it("notifies delegates with categories") {
                        let bundle = Bundle(for: type(of: self))
                        let path = bundle.path(forResource: "Club", ofType: "json")!
                        let url = URL(fileURLWithPath: path)
                        let clubJSON = try! String(contentsOf: url, encoding: .utf8)
                        mockTasoClient.webResponse = WebResponse(data: clubJSON.data(using: .utf8)!, statusCode: 200)
                        
                        dataService.populateCategories()
                        
                        expect(mockDelegate.categoriesPopulatedCalled).toEventually(beTrue())
                        expect(mockDelegate.categoriesPopulatedCategories?.count).toEventually(equal(3))
                        expect(mockDelegate.categoriesPopulatedError).toEventually(beNil())
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
        }
    }
}

class MockDataServiceDelegate: DataServiceDelegate {
    var id: String = "MockDataServiceDelegate"
    
    var categoriesPopulatedCalled = false
    var categoriesPopulatedCategories: [TasoCategory]?
    var categoriesPopulatedError: Error?
    
    var teamsPopulatedCalled = false
    var teamsPopulatedTeams: [TasoTeam]?
    var teamsPopulatedError: Error?
    
    func categoriesPopulated(categories: [TasoCategory]?, error: Error?) {
        categoriesPopulatedCalled = true
        categoriesPopulatedCategories = categories
        categoriesPopulatedError = error
    }
    
    func teamsPopulated(teams: [TasoTeam]?, error: Error?) {
        teamsPopulatedCalled = true
        teamsPopulatedTeams = teams
        teamsPopulatedError = error
    }
}
