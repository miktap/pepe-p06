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
            var club: TasoClub!
            beforeEach {
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "Club", ofType: "json")!
                let url = URL(fileURLWithPath: path)
                let clubJSON = try! String(contentsOf: url, encoding: .utf8)
                club = TasoClubListing(JSONString: clubJSON)!.club!
            }
            
            describe("getCategories") {
                context("when teams and competitionsIncluding are nil") {
                    it("gets all categories") {
                        let result = TasoClubFilter.getCategories(club: club)
                        
                        expect(result.count).to(equal(12))
                    }
                }
                
                context("when teams is nil but competitionsIncluding has values") {
                    it("selects matching categories from all teams") {
                        let result = TasoClubFilter.getCategories(club: club, teams: nil, competitionsIncluding: ["Jalkapallo", "Futsal"])
                        
                        expect(result.count).to(equal(7))
                    }
                }
                
                context("when teams and competitionsIncluding have values") {
                    it("selects matching categories from the given teams") {
                        let result = TasoClubFilter.getCategories(club: club, teams: ["109887"], competitionsIncluding: ["Jalkapallo", "Futsal"])
                        
                        expect(result.count).to(equal(2))
                    }
                }
            }
            
            describe("getTeamsAndCategories") {
                context("when club contains no matching teams") {
                    it("returns empty") {
                        let result = TasoClubFilter.getTeamsAndCategories(club: club, teams: ["1","2"], competitionsIncluding: Constants.Settings.selectedCompetitions)
                        
                        expect(result).to(beEmpty())
                    }
                }
                
                context("when club contains matching teams but no matching categories") {
                    it("returns only teams") {
                        let result = TasoClubFilter.getTeamsAndCategories(club: club, teams: Constants.Settings.selectedTeams, competitionsIncluding: ["huuhaa"])
                        
                        expect(result.keys.count).to(equal(2))
                        result.keys.forEach {expect(result[$0]!).to(beEmpty())}
                    }
                }
                
                context("when club contains matching teams and matching categories") {
                    it("returns teams with categories") {
                        let result = TasoClubFilter.getTeamsAndCategories(club: club)
                        
                        expect(result.keys.count).to(equal(2))
                        expect(result.values.flatMap{$0}.count).to(equal(3))
                    }
                }
            }
        }
    }
}
