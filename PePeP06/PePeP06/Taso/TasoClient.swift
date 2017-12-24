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
     * Get a team with a team ID.
     *
     * - Parameter id: Team ID
     * - Returns: A promise of a `WebResponse`
     */
    func getTeam(id: Int) -> Promise<WebResponse>?
}

/**
 *
 * Taso REST API query consists of a mandatory 'api_key' and optional other queries.
 *
 */
struct TasoQuery {
    /// Unique API key for PePe
    let api_key = "dzsf36wmek"
    /// Optional query parameter as dictionary
    var queries = [String: String]()
    
    /// Generated URL query
    var output: [URLQueryItem] {
        get {
            var result = [URLQueryItem]()
            result.append(URLQueryItem(name: "api_key", value: api_key))
            queries.forEach {
                result.append(URLQueryItem(name: $0.key, value: $0.value))
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
    let tasoUrl = "https://spl.torneopal.fi/taso/rest/"
    
    func getTeam(id: Int) -> Promise<WebResponse>? {
        let query = TasoQuery(queries: ["team_id": String(id)])
        let request = WebRequest(url: tasoUrl + "getTeam", method: "GET", queryParams: query.output, headers: nil, body: nil)
        return invoke(webRequest: request)
    }
}
