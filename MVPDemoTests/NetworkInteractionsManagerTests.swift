//
//  NetworkInteractionsManagerTests.swift
//  MVPDemoTests
//
//  Created by Sanooj on 22/09/2018.
//  Copyright © 2018 Sanooj. All rights reserved.
//

import XCTest
@testable import MVPDemo

class NetworkInteractionsManagerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension NetworkInteractionsManagerTests {
    
    func testCreateURLFromComponents() {
        
        let urlToTest: URL! =
        URL.init(string: "https://itunes.apple.com/search?term=jack+johnson&limit=25")
        
        let baseURL: String =
            NetworkInteractionsManager.URLEndPoints.baseURL + "search?"
        
        let termQuery: URLQueryItem =
        URLQueryItem.init(name: "term" , value: "jack+johnson")
        
        let limitQuery: URLQueryItem =
            URLQueryItem.init(name: "limit" , value: "25")
        
        var urlComponents: URLComponents! =
            URLComponents.init(string: baseURL)
        
        urlComponents.queryItems =
        [termQuery,limitQuery]
        
        XCTAssertEqual(urlToTest, urlComponents.url!)
    
    }
    
    func testURLBuilderInterface() {
        
        let urlToTest: URL! =
            URL.init(string: "https://itunes.apple.com/search?limit=25&term=jack+johnson")
        
        let builder = NetworkInteractionsManager()
        
        let url: URL! =
        builder.urlBuilder
            .baseUrl(NetworkInteractionsManager.URLEndPoints.baseURL)
            .addPathComponents(
                ["search"]
            )
            .addQueries([
                "term" : "jack+johnson" ,
                "limit" : "25"
                ])
            .build()
    
        XCTAssertEqual(
            urlToTest.baseURL,
            url.baseURL
        )
        
        XCTAssertEqual(
            urlToTest.path ,
            url.path
        )
        
        XCTAssertEqual(
            Set(urlToTest!.query!.split(separator: "&")) ,
            Set(url!.query!.split(separator: "&"))
        )
        
    }
    
    func testURLRequestBuilderInterface() {
        
        let urlToTest: URL! =
            URL.init(string: "https://itunes.apple.com/search?limit=25&term=jack+johnson")
        
        let httpmethod = "GET"
        
        let httpHeaders: [String:String] = [:]
        
        let httpBody: Data? = nil
        
        let request: URLRequest! =
        URLRequest.init(url: urlToTest)
        
        let builder = NetworkInteractionsManager()
        
        let urlRequest: URLRequest? =
        builder.urlRequestBuilder
            .requestUrl(urlToTest)
            .requestType(httpmethod)
            .addBody(httpBody)
            .addHTTPHeaderFields(httpHeaders)
            .build()
        
        XCTAssertEqual(request, urlRequest)
        
    }
    
    func testNetworkInteractionsManagerRequestBuilding() {
        
        let urlToTest: URL! =
            URL.init(string: "https://itunes.apple.com/search?limit=25&term=jack+johnson")
        
        let httpmethod = "GET"
        
        let httpHeaders: [String:String] = [:]
        
        let httpBody: Data? = nil
        
        let request: URLRequest! =
            URLRequest.init(url: urlToTest)
        
        let builder = NetworkInteractionsManager()
        
        let url: URL! =
            builder.urlBuilder
                .baseUrl(NetworkInteractionsManager.URLEndPoints.baseURL)
                .addPathComponents(
                    ["search"]
                )
                .addQueries([
                    "term" : "jack+johnson" ,
                    "limit" : "25"
                    ])
                .build()
        
        let urlRequest: URLRequest? =
            builder.urlRequestBuilder
                .requestUrl(url)
                .requestType(httpmethod)
                .addBody(httpBody)
                .addHTTPHeaderFields(httpHeaders)
                .build()
        
        XCTAssertEqual(request, urlRequest)
        
    }
    
    
    func testNetworkInteractionsManager() {
        
        let expectation = XCTestExpectation.init(description: "Netwrokinvoke")
        
        let urlToTest: URL! =
            URL.init(string: "https://itunes.apple.com/search?limit=25&term=jack+johnson")
        
        let httpmethod = "GET"
        
        let httpHeaders: [String:String] = [:]
        
        let httpBody: Data? = nil
        
        let request: URLRequest! =
            URLRequest.init(url: urlToTest)
        
        let builder = NetworkInteractionsManager()
        
        let url: URL! =
            builder.urlBuilder
                .baseUrl(NetworkInteractionsManager.URLEndPoints.baseURL)
                .addPathComponents(
                    ["search"]
                )
                .addQueries([
                    "term" : "jack+johnson" ,
                    "limit" : "25"
                    ])
                .build()
        
        let urlRequest: URLRequest! =
            builder.urlRequestBuilder
                .requestUrl(url)
                .requestType(httpmethod)
                .addBody(httpBody)
                .addHTTPHeaderFields(httpHeaders)
                .build()
        
        builder.urlSessionBuilder
            .urlSession(URLSessionType.shared)
            .addConfiguration(URLSessionConfiguration.default)
            .addTasks([
                URLSessionConfigurableTask
                    .init(request: urlRequest!)
                    .taskType(URLSessionTaskType.data)
                    .addData(nil)
                    .callBack({ (data:Data?, response:URLResponse?, error:Error?) in
                        
                        print((response as? HTTPURLResponse)?.statusCode as Any)
                        
                        print(String.init(data: data ?? Data(), encoding: String.Encoding.utf8) as Any)
                        
                        expectation.fulfill()
                })
                ])
            .launch()
    
        
        wait(for: [expectation], timeout: TimeInterval.init(30))
        
        XCTAssertNil(builder.urlSessionBuilder.error)
        
    }
    
}
