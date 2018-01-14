//
//  MockTasoClient.swift
//  PePeP06Tests
//
//  Created by Mikko Tapaninen on 28/12/2017.
//

import Foundation
import PromiseKit
@testable import PePeP06

class MockTasoClient: TasoClientProtocol {
    var team_id: String?
    var competition_id: String?
    var category_id: String?
    var current: String?
    var season_id: String?
    var organiser: String?
    var region: String?
    var all_current: String?
    var club_id: String?
    var player_id: String?
    var group_id: String?
    var matches: String?
    
    var rejectPromise = false
    var webResponse: WebResponse?
    
    
    func getTeam(team_id: String, competition_id: String?, category_id: String?) -> Promise<WebResponse>? {
        self.team_id = team_id
        self.competition_id = competition_id
        self.category_id = category_id
        
        return Promise {fulfill, reject in
            if rejectPromise {
                reject(NSError(domain: "dummy", code: 0, userInfo: nil))
            } else {
                fulfill(webResponse!)
            }
        }
    }
    
    func getCompetitions(current: String?, season_id: String?, organiser: String?, region: String?) -> Promise<WebResponse>? {
        self.current = current
        self.season_id = season_id
        self.organiser = organiser
        self.region = region
        
        return Promise {fulfill, reject in
            if rejectPromise {
                reject(NSError(domain: "dummy", code: 0, userInfo: nil))
            } else {
                fulfill(webResponse!)
            }
        }
    }
    
    func getCategories(competition_id: String?, category_id: String?, organiser: String?, all_current: String?) -> Promise<WebResponse>? {
        self.competition_id = competition_id
        self.category_id = category_id
        self.organiser = organiser
        self.all_current = all_current
        
        return Promise {fulfill, reject in
            if rejectPromise {
                reject(NSError(domain: "dummy", code: 0, userInfo: nil))
            } else {
                fulfill(webResponse!)
            }
        }
    }
    
    func getClub(club_id: String?) -> Promise<WebResponse>? {
        self.club_id = club_id
        
        return Promise {fulfill, reject in
            if rejectPromise {
                reject(NSError(domain: "dummy", code: 0, userInfo: nil))
            } else {
                fulfill(webResponse!)
            }
        }
    }
    
    func getPlayer(player_id: String) -> Promise<WebResponse>? {
        self.player_id = player_id
        
        return Promise {fulfill, reject in
            if rejectPromise {
                reject(NSError(domain: "dummy", code: 0, userInfo: nil))
            } else {
                fulfill(webResponse!)
            }
        }
    }
    
    func getGroup(competition_id: String, category_id: String, group_id: String, matches: String?) -> Promise<WebResponse>? {
        self.competition_id = competition_id
        self.category_id = category_id
        self.group_id = group_id
        self.matches = matches
        
        return Promise {fulfill, reject in
            if rejectPromise {
                reject(NSError(domain: "dummy", code: 0, userInfo: nil))
            } else {
                fulfill(webResponse!)
            }
        }
    }
}
