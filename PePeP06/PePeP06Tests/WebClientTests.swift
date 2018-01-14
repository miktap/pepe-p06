//
//  WebClientTests.swift
//  PePeP06Tests
//
//  Created by Mikko Tapaninen on 24/12/2017.
//

import Quick
import Nimble
@testable import PePeP06

class WebClientTests: QuickSpec {
    override func spec() {
        describe("WebRequest") {
            context("when all properties are non-nil") {
                it("creates urlRequest with proper data") {
                    let request = WebRequest(url: "https://taso.fi/getTeam", method: "GET", queryParams: [URLQueryItem(name: "team_id", value: "123")], headers: ["some":"value"], body: "foo")
                    
                    let result = request.urlRequest
                    
                    expect(result!.url!.absoluteString).to(equal("https://taso.fi/getTeam?team_id=123"))
                    expect(result!.allHTTPHeaderFields).to(equal(["some":"value"]))
                    expect(result!.httpBody).to(equal("foo".data(using: .utf8)))
                }
            }
            
            context("when queryparams is nil") {
                it("creates urlRequest with proper data") {
                    let request = WebRequest(url: "https://taso.fi/getTeam", method: "GET", queryParams: nil, headers: ["some":"value"], body: "foo")
                    
                    let result = request.urlRequest
                    
                    expect(result!.url!.absoluteString).to(equal("https://taso.fi/getTeam"))
                    expect(result!.allHTTPHeaderFields).to(equal(["some":"value"]))
                    expect(result!.httpBody).to(equal("foo".data(using: .utf8)))
                }
            }
            
            context("when headers is nil") {
                it("creates urlRequest with proper data") {
                    let request = WebRequest(url: "https://taso.fi/getTeam", method: "GET", queryParams: [URLQueryItem(name: "team_id", value: "123")], headers: nil, body: "foo")
                    
                    let result = request.urlRequest
                    
                    expect(result!.url!.absoluteString).to(equal("https://taso.fi/getTeam?team_id=123"))
                    expect(result!.allHTTPHeaderFields).to(beEmpty())
                    expect(result!.httpBody).to(equal("foo".data(using: .utf8)))
                }
            }
            
            context("when body is nil") {
                it("creates urlRequest with proper data") {
                    let request = WebRequest(url: "https://taso.fi/getTeam", method: "GET", queryParams: [URLQueryItem(name: "team_id", value: "123")], headers: ["some":"value"], body: nil)
                    
                    let result = request.urlRequest
                    
                    expect(result!.url!.absoluteString).to(equal("https://taso.fi/getTeam?team_id=123"))
                    expect(result!.allHTTPHeaderFields).to(equal(["some":"value"]))
                    expect(result!.httpBody).to(beNil())
                }
            }
            
            context("when url is not valid") {
                it("returns nil") {
                    let request = WebRequest(url: "%%", method: "GET", queryParams: [URLQueryItem(name: "team_id", value: "123")], headers: ["some":"value"], body: "foo")
                    
                    let result = request.urlRequest
                    
                    expect(result).to(beNil())
                }
            }
        }
    }
}

