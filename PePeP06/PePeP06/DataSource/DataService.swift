//
//  DataService.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 27/12/2017.
//

import Foundation
import PromiseKit

protocol DataServiceDelegate {
    var id: String {get}
    
    /**
     * Categories have been populated.
     *
     * - Parameter categories: Populated categories or nil in case of an error
     * - Parameter error: Error or nil if operation was successfull
     */
    func categoriesPopulated(categories: [TasoCategory]?, error: Error?)
    
    /**
     * Teams have been populated.
     *
     * - Parameter teams: Populated teams or nil in case of an error
     * - Parameter error: Error or nil if operation was successfull
     */
    func teamsPopulated(teams: [TasoTeam]?, error: Error?)
}

enum DataServiceError: Error {
    case responseError(String)
    case parseError(String)
    case unknownError(String)
}

/**
 *
 * `DataService` class provides methods to populate data models used by various views.
 *
 */
class DataService {
    // MARK: - Properties
    
    var dataClient: TasoClientProtocol
    var delegates = [DataServiceDelegate]()
    
    
    // MARK: - Initialization
    
    init(client: TasoClientProtocol) {
        dataClient = client
    }
    
    
    // MARK: - Add/remove delegates
    
    func addDelegate(delegate: DataServiceDelegate) {
        if !delegates.contains(where: { $0.id == delegate.id } ) {
            log.debug("Add new DataServiceDelegate with id: '\(delegate.id)'")
            delegates.append(delegate)
        }
    }
    
    func removeDelegate(delegate: DataServiceDelegate) {
        if let index = delegates.index(where: { $0.id == delegate.id} ) {
            log.debug("Remove DataServiceDelegate with id: '\(delegate.id)'")
            delegates.remove(at: index)
        }
    }
    
    
    // MARK: - Methods
    
    /**
     * Get a club and filter selected categories from it. Notify delegates.
     */
    @objc func populateCategories() {
        dataClient.getClub(club_id: Constants.Settings.selectedClubID)?
            .then { response -> Void in
                log.debug("Status code: \(response.statusCode)")
                if let data = response.data, let message = String(data: data, encoding: .utf8) {
                    log.debug("Message: \(message)")
                    if let clubListing = TasoClubListing(JSONString: message), let club = clubListing.club {
                        log.debug("Got club: \(club.name ?? "")")
                        let categories = ClubFilter.getCategories(club: club,
                                                                   teams: Constants.Settings.selectedTeams,
                                                                   competitionsIncluding: Constants.Settings.selectedCompetitions)
                        self.delegates.forEach {$0.categoriesPopulated(categories: categories, error: nil)}
                    } else {
                        self.delegates.forEach {$0.categoriesPopulated(categories: nil, error: DataServiceError.parseError("Problems parsing Taso response to a club"))}
                    }
                } else {
                    self.delegates.forEach {$0.categoriesPopulated(categories: nil, error: DataServiceError.responseError("Problems with Taso response data"))}
                }
            }.catch { error in
                self.delegates.forEach {$0.categoriesPopulated(categories: nil, error: DataServiceError.unknownError(error.localizedDescription))}
        }
    }
    
    /**
     * Get teams and notify delegates.
     *
     * - Parameter team_ids: IDs of teams to get
     */
    func populateTeams(team_ids: [String]) {
        var promises = [Promise<WebResponse>]()
        team_ids.forEach {
            if let promise = dataClient.getTeam(team_id: $0, competition_id: nil, category_id: nil) {
                promises.append(promise)
            }
        }
        
        when(fulfilled: promises)
            .then { results -> Void in
                var teams = [TasoTeam]()
                var error = false
                results.forEach { response in
                    if let data = response.data, let message = String(data: data, encoding: .utf8) {
                        log.debug("Message: \(message)")
                        if let teamListing = TasoTeamListing(JSONString: message), let team = teamListing.team {
                            log.debug("Got team: \(team.team_name ?? "")")
                            teams.append(team)
                        } else {
                            error = true
                        }
                    } else {
                        error = true
                    }
                }
                if error {
                    self.delegates.forEach {$0.teamsPopulated(teams: nil, error: DataServiceError.responseError("Problems with Taso response data"))}
                } else {
                    self.delegates.forEach {$0.teamsPopulated(teams: teams, error: nil)}
                }
            }.catch { error in
                self.delegates.forEach {$0.teamsPopulated(teams: nil, error: DataServiceError.unknownError(error.localizedDescription))}
        }
    }
}