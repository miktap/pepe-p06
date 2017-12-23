//
//  WebClient.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 23/12/2017.
//

import Foundation
import PromiseKit

struct WebRequest {
    var httpMethod: String
    var url: String
    var queryParams: [URLQueryItem]?
    var headers: [String: String]?
    var httpBody: String?
}

struct WebResponse {
    var headers: [String: String]?
    var responseData: Data?
    var rawResponse: HTTPURLResponse
    var statusCode: Int
}

enum RequestInvokeError: Error {
    case invalidRequest(String)
    case invalidResponse(String)
    case unknownError(String)
}

/**
 *
 * WebClient is responsible of sending requests (of type `WebRequest`).
 * Responses are parsed as `WebResponse` objects and returned as a promise.
 *
 */
class WebClient {
    var session: URLSession
    var baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: .default)
    }

    /**
     * Invoke a web request.
     *
     * - Parameter request: Request to invoke.
     * - Returns: A promise of a `WebResponse`.
     */
    func invoke(request: WebRequest) -> Promise<WebResponse> {
        return Promise { fulfill, reject in
            guard let request = buildRequest(request: request) else {
                log.error("Unable to create URL request")
                return reject(RequestInvokeError.invalidRequest("Unable to create request"))
            }
            
            let sessionTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    reject(error)
                } else if let HTTPResponse = response as? HTTPURLResponse {
                    let result = WebResponse(headers: HTTPResponse.allHeaderFields as? [String: String], responseData: data, rawResponse: HTTPResponse, statusCode: HTTPResponse.statusCode)
                    fulfill(result)
                } else {
                    reject(RequestInvokeError.invalidResponse("Received response was not 'HTTPURLResponse'"))
                }
            }
            
            log.debug("Invoking web request")
            sessionTask.resume()
        }
    }

    /**
     * Build `URLRequest` from `WebRequest`.
     *
     * - Parameter request: An input `WebRequest` object.
     * - Returns: A `URLRequest` object.
     */
    func buildRequest(request: WebRequest) -> URLRequest? {
        let fullUrl = baseURL + request.url
        guard let urlComponents = URLComponents(string: fullUrl) else {
            log.error("Unable to create URLComponents from '\(fullUrl)")
            return nil
        }

        // Add query parameters
        var mutableUrlComponents = urlComponents
        mutableUrlComponents.queryItems = request.queryParams

        if let url = mutableUrlComponents.url {
            var result = URLRequest(url: url)

            result.httpMethod = request.httpMethod
            result.httpBody = request.httpBody?.data(using: .utf8)
            result.allHTTPHeaderFields = request.headers
            
            log.debug("Request details:")
            log.debug("\t URL: \(result.url!)")
            log.debug("\t HTTP method: \(result.httpMethod!)")
            log.debug("\t HTTP headers: \(result.allHTTPHeaderFields ?? ["":""])")
            log.debug("\t HTTP body: " + printBody(request: result))
            
            return result
        } else {
            log.error("Unable to create URL from '\(mutableUrlComponents)'")
            return nil
        }
    }

    private func printBody(request: URLRequest) -> String {
        if let body = request.httpBody {
            if let dataString = String(data: body, encoding: .utf8) {
                return dataString
            } else {
                return "\(body)"
            }
        }

        return ""
    }
}

