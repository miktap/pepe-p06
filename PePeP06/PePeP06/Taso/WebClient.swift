//
//  WebClient.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 23/12/2017.
//

import Foundation
import PromiseKit

struct WebRequest {
    var url: String
    var method: String
    var queryParams: [URLQueryItem]?
    var headers: [String: String]?
    var body: String?
    
    var urlRequest: URLRequest? {
        get {
            guard let urlComponents = URLComponents(string: url) else {
                log.error("Unable to create URLComponents from '\(url)")
                return nil
            }

            var mutableUrlComponents = urlComponents
            mutableUrlComponents.queryItems = queryParams
            
            if let url = mutableUrlComponents.url {
                var result = URLRequest(url: url)
                result.httpMethod = method
                result.allHTTPHeaderFields = headers
                result.httpBody = body?.data(using: .utf8)
                
                return result
            } else {
                log.error("Unable to create URL from \(mutableUrlComponents)")
                return nil
            }
        }
    }
}

struct WebResponse {
    var data: Data?
    var statusCode: Int
}

enum WebClientError: Error {
    case invalidResponse(String)
}

/**
 *
 * WebClient provides `invoke(request:)` method for sending URL requests.
 * Responses are parsed as `WebResponse` objects and returned as a promise.
 *
 */
class WebClient {
    var session: URLSession

    init() {
        self.session = URLSession(configuration: .default)
    }

    /**
     * Invoke a web request.
     *
     * - Parameter request: Request to invoke.
     * - Returns: A promise of a `WebResponse`.
     */
    func invoke(webRequest: WebRequest) -> Promise<WebResponse>? {
        guard let request = webRequest.urlRequest else {
            return nil
        }
        
        return Promise { fulfill, reject in
            let sessionTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    reject(error)
                } else if let HTTPResponse = response as? HTTPURLResponse {
                    let result = WebResponse(data: data, statusCode: HTTPResponse.statusCode)
                    fulfill(result)
                } else {
                    reject(WebClientError.invalidResponse("Received response was not 'HTTPURLResponse'"))
                }
            }
            
            log.debug("Invoking web request:")
            log.debug("\t URL: \(request.url?.absoluteString ?? "")")
            log.debug("\t HTTP method: \(request.httpMethod ?? "")")
            log.debug("\t HTTP headers: \(String(describing: request.allHTTPHeaderFields))")
            log.debug("\t HTTP body: " + printBody(request: request))

            sessionTask.resume()
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

