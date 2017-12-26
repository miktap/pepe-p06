//
//  TasoClient.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 23/12/2017.
//

import Foundation
import PromiseKit

protocol TasoClientProtocol {
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
     * - Parameter organizer (Optional): Only list selected organiser (example spl)
     * - Parameter region (Optional): Only list selected region (example spl)
     */
    func getCompetitions(current: String?, season_id: String?, organizer: String?, region: String?) -> Promise<WebResponse>?
    
    /**
     * Get a list of all categories in a competition or all competitions with the category.
     * One of [all_current|competition_id|category_id] is required.
     *
     * - Parameter competition_id: Competition id
     * - Parameter category_id: Category id
     * - Parameter organiser: Organiser id
     * - Parameter all_current: List all current (1), not archived (0) categories
     */
    func getCategories(competition_id: String?, category_id: String?, organiser: String?, all_current: String?) -> Promise<WebResponse>?
}

/**
 *
 * Taso REST API query consists of a mandatory 'api_key' and optional other queries.
 *
 */
struct TasoQuery {
    /// Unique API key for PePe
    let api_key = "dzsf36wmek"
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

/**
 *
 * Taso REST API client.
 *
 */
class TasoClient: WebClient, TasoClientProtocol {
    // MARK: - Properties
    
    let tasoUrl = "https://spl.torneopal.fi/taso/rest/"
    
    
    // MARK: - TasoClientProtocol
    
    func getTeam(team_id: String, competition_id: String? = nil, category_id: String? = nil) -> Promise<WebResponse>? {
        let query = TasoQuery(queries: [URLQueryItem(name:"team_id", value: team_id)])
        let request = WebRequest(url: tasoUrl + "getTeam", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    func getCompetitions(current: String? = nil, season_id: String? = nil, organizer: String? = nil, region: String? = nil) -> Promise<WebResponse>? {
        var query = TasoQuery()
        query.queries = [
            URLQueryItem(name: "current", value: current),
            URLQueryItem(name: "season_id", value: season_id),
            URLQueryItem(name: "organizer", value: organizer),
            URLQueryItem(name: "query", value: region)
        ]

       let request = WebRequest(url: tasoUrl + "getCompetitions", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
    
    func getCategories(competition_id: String? = nil, category_id: String? = nil, organiser: String? = nil, all_current: String? = nil) -> Promise<WebResponse>? {
        var query = TasoQuery()
        query.queries = [
            URLQueryItem(name: "competition_id", value: competition_id),
            URLQueryItem(name: "category_id", value: category_id),
            URLQueryItem(name: "organiser", value: organiser),
            URLQueryItem(name: "all_current", value: all_current)
        ]
        
        let request = WebRequest(url: tasoUrl + "getCategories", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
}
