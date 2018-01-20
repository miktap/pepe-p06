//
//  TasoClient.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 23/12/2017.
//

import Foundation
import PromiseKit

protocol TasoClientProtocol {
    var delegate: TasoClientDelegate? {get set}
    
    /**
     * Initialize TasoClient.
     */
    func initialize()
    
    /**
     * Get a team.
     *
     * - Parameter team_id: Team ID to get current roster
     * - Parameter competition_id (Optional): ?
     * - Parameter category_id (Optional): ?
     * - Returns: A promise of a `WebResponse`
     */
    func getTeam(team_id: String, competition_id: String?, category_id: String?) -> Promise<WebResponse>?
    
    /**
     * Get competitions.
     *
     * - Parameter current (Optional): Only list current competitions (1), not archived (0)
     * - Parameter season_id (Optional): Only list selected season (example 2018)
     * - Parameter organiser (Optional): Only list selected organiser (example spl)
     * - Parameter region (Optional): Only list selected region (example spl)
     * - Returns: A promise of a `WebResponse`
     */
    func getCompetitions(current: String?, season_id: String?, organiser: String?, region: String?) -> Promise<WebResponse>?
    
    /**
     * Get a list of all categories in a competition or all competitions with the category.
     * One of [all_current|competition_id|category_id] is required.
     *
     * - Parameter competition_id: Competition id
     * - Parameter category_id: Category id
     * - Parameter organiser: Organiser id
     * - Parameter all_current: List all current (1), not archived (0) categories
     * - Returns: A promise of a `WebResponse`
     */
    func getCategories(competition_id: String?, category_id: String?, organiser: String?, all_current: String?) -> Promise<WebResponse>?
    
    /**
     * Get a club.
     *
     * - Parameter club_id: Club ID. This parameter is not used with Club API Keys. Call will always return your own
     * club when called with Club API Key
     * - Returns: A promise of a `WebResponse`
     */
    func getClub(club_id: String?) -> Promise<WebResponse>?
    
    /**
     * Get a player.
     *
     * - Parameter player_id: Player ID
     * - Returns: A promise of a `WebResponse`
     */
    func getPlayer(player_id: String) -> Promise<WebResponse>?
    
    /**
     * Get a group.
     *
     * - Parameter competition_id: Competition ID
     * - Parameter category_id: Category ID
     * - Parameter group_id: Group ID
     * - Parameter matches (Optional): List matches (1) or not (0), by default 0
     */
    func getGroup(competition_id: String, category_id: String, group_id: String, matches: String?) -> Promise<WebResponse>?
}

/**
 *
 * Taso REST API query consists of a mandatory 'api_key' and optional other queries.
 *
 */
struct TasoQuery {
    var api_key: String?
    /// Optional queries
    var queries = [URLQueryItem]()
    
    /// Generated URL query
    var output: [URLQueryItem] {
        get {
            var result = [URLQueryItem]()
            result.append(URLQueryItem(name: "api_key", value: api_key))
            queries.forEach {
                if $0.value != nil {
                    result.append($0)
                }
            }
            return result
        }
    }
}

protocol TasoClientDelegate {
    /**
     * Taso client is ready.
     */
    func tasoClientReady()
}

/**
 *
 * Taso REST API client.
 *
 */
class TasoClient: WebClient, TasoClientProtocol, S3ClientDelegate {
    // MARK: - Properties
    
    /// Unique API key for PePe
    var api_key: String? {
        didSet {
            delegate?.tasoClientReady()
        }
    }
    
    /// Base URL for all Taso queries
    let tasoUrl = "https://spl.torneopal.fi/taso/rest/"
    var delegate: TasoClientDelegate?
    
    
    // MARK: - Initialization
    
    func initialize() {
        let s3Client = S3Client()
        s3Client.delegate = self
        s3Client.getTasoAPIKey()
    }
    
    
    // MARK: - TasoClientProtocol
    
    func getTeam(team_id: String, competition_id: String? = nil, category_id: String? = nil) -> Promise<WebResponse>? {
        let queries = [
            URLQueryItem(name: "team_id", value: team_id),
            URLQueryItem(name: "competition_id", value: competition_id),
            URLQueryItem(name: "category_id", value: category_id)
        ]
        let query = TasoQuery(api_key: api_key, queries: queries)

        let request = WebRequest(url: tasoUrl + "getTeam", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    func getCompetitions(current: String? = nil, season_id: String? = nil, organiser: String? = nil, region: String? = nil) -> Promise<WebResponse>? {
        let queries = [
            URLQueryItem(name: "current", value: current),
            URLQueryItem(name: "season_id", value: season_id),
            URLQueryItem(name: "organiser", value: organiser),
            URLQueryItem(name: "query", value: region)
        ]
        let query = TasoQuery(api_key: api_key, queries: queries)

        let request = WebRequest(url: tasoUrl + "getCompetitions", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    func getCategories(competition_id: String? = nil, category_id: String? = nil, organiser: String? = nil, all_current: String? = nil) -> Promise<WebResponse>? {
        let queries = [
            URLQueryItem(name: "competition_id", value: competition_id),
            URLQueryItem(name: "category_id", value: category_id),
            URLQueryItem(name: "organiser", value: organiser),
            URLQueryItem(name: "all_current", value: all_current)
        ]
        let query = TasoQuery(api_key: api_key, queries: queries)
        
        let request = WebRequest(url: tasoUrl + "getCategories", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    func getClub(club_id: String? = nil) -> Promise<WebResponse>? {
        let query = TasoQuery(api_key: api_key, queries: [URLQueryItem(name: "club_id", value: club_id)])
        let request = WebRequest(url: tasoUrl + "getClub", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    func getPlayer(player_id: String) -> Promise<WebResponse>? {
        let query = TasoQuery(api_key: api_key, queries: [URLQueryItem(name: "player_id", value: player_id)])
        let request = WebRequest(url: tasoUrl + "getPlayer", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    func getGroup(competition_id: String, category_id: String, group_id: String, matches: String? = nil) -> Promise<WebResponse>? {
        let queries = [
            URLQueryItem(name: "competition_id", value: competition_id),
            URLQueryItem(name: "category_id", value: category_id),
            URLQueryItem(name: "group_id", value: group_id),
            URLQueryItem(name: "matches", value: matches)
        ]
        let query = TasoQuery(api_key: api_key, queries: queries)
        
        let request = WebRequest(url: tasoUrl + "getGroup", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    
    // MARK: - S3ClientDelegate
    
    func apiKeyReceived(api_key: String) {
        self.api_key = api_key
    }
}
