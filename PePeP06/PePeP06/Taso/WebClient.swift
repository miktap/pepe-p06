//
//  WebClient.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 23/12/2017.
//

import Foundation
import PromiseKit

struct WebRequest {
    var HTTPMethod: String
    var URL: String?
    var queryParams: [URLQueryItem]?
    var headers: [String: String]
    var HTTPBody: [String: Any]?
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
     * - Parameter request:
     * - Returns:
     */
    func invoke(request: URLRequest) -> Promise<WebResponse> {
        return Promise { fulfill, reject in
//            guard let request = buildRequest(apiRequest: apiRequest) else {
//                log.error("Unable to create request")
//                return reject(RequestInvokeError.invalidRequest("Unable to create request"))
//            }

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

//    /**
//     * Build `NSMutableURLRequest` from `WebRequest`. This includes:
//     *   - Create the `URL`
//     *   - Add HTTP method
//     *   - Add HTTP headers
//     *   - Add HTTP body
//     *
//     * - Parameter request: An input `WebRequest` object
//     * - Returns: A `NSMutableURLRequest` object.
//     */
//    func buildRequest(request: AGWRequest) -> NSMutableURLRequest? {
//        let fullUrl = baseURL + (apiRequest.URLString ?? "")
//        guard let url = URLComponents(string: fullUrl) else {
//            log.error("Unable to create URL from '\(fullUrl)")
//            return nil
//        }
//
//        // Add query parameters, encode them first with AWS URL encoding rules
//        var mutableUrl = url
//        var newQueryParameters = [URLQueryItem]()
//        if let query = request.queryParameters {
//            for item in query {
//                let name = (item.name as NSString).aws_stringWithURLEncoding() ?? ""
//                let value = ((item.value ?? "") as NSString).aws_stringWithURLEncoding() ?? ""
//                newQueryParameters.append(URLQueryItem(name: name, value: value))
//            }
//        }
//        if newQueryParameters.count > 0 {
//            mutableUrl.queryItems = newQueryParameters
//        }
//
//        let request = NSMutableURLRequest(url: mutableUrl.url!)
//        request.httpMethod = apiRequest.HTTPMethod
//        request.allHTTPHeaderFields = apiRequest.headerParameters
//
//        let dateNow = Date()
//
//        // Handle 'x-amz-date' header
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
//        dateFormatter.locale = Locale(identifier: locale)
//        dateFormatter.dateFormat = dateFormat
//        let dateString = dateFormatter.string(from: dateNow)
//        request.setValue(dateString, forHTTPHeaderField: amazonDateHeader)
//
//        // Add Nuviz headers
//        request.setValue(nuvizApiVersion, forHTTPHeaderField: nuvizApiVersionHeader)
//        request.setValue(getPlatformName() + ";" + getDeviceModel(), forHTTPHeaderField: nuvizPlatformHeader)
//        request.setValue(getNuvizDateHeader(date: dateNow), forHTTPHeaderField: nuvizDateHeader)
//        request.setValue(getAppVersion(), forHTTPHeaderField: nuvizAppVersion)
//
//        // Add body
//        if let body = apiRequest.HTTPBody {
//            let dataString = JsonParser.JSONStringify(body as AnyObject)
//            let data = dataString.data(using: .utf8)
//            request.httpBody = data
//        }
//
//        log.debug("Request details:")
//        log.debug("\t URL: " + (request.url != nil ? request.url!.absoluteString : "nil"))
//        log.debug("\t HTTP method: " + request.httpMethod)
//        log.debug("\t HTTP headers: " + JsonParser.JSONStringify(request.allHTTPHeaderFields as AnyObject))
//        log.debug("\t HTTP body: " + printBody(request: request))
//
//        return request
//    }
//
//    private func printBody(request: NSMutableURLRequest) -> String {
//        if let body = request.httpBody {
//            if let dataString = String.init(data: body, encoding: .utf8) {
//                return dataString
//            } else {
//                return "\(body)"
//            }
//        }
//
//        return "nil"
//    }

}

