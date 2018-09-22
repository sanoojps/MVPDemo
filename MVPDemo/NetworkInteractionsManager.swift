//
//  NetworkInteractionsManager.swift
//  MVPDemo
//
//  Created by Sanooj on 22/09/2018.
//  Copyright © 2018 Sanooj. All rights reserved.
//

import Foundation
enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

protocol URLBuilderInterface {
    
    var pathComponents: [String] {get}
    var queries: [URLQueryItem] {get}
    var baseUrl: String {get}
    var percentEncodedUrl: String {get}
    var url: URL? {get}
    
    func baseUrl(_ baseUrl:String) -> Self
    func addQueries(_ queries:[String:String]) -> Self
    func addPathComponents(_ componets: [String]) -> Self
    func applyPercentEncoding() -> Self
    func build() -> URL?
    
}

protocol URLRequestBuilderInterface {
    
    var httpMethod: String {get}
    var httpBody: Data? {get}
    var allHTTPHeaderFields: [String:String] {get}
    var requestUrl: URL? {get}
    
    func requestUrl(_ requestUrl:URL) -> Self
    func requestType(_ httpMethod:String) -> Self
    func addBody(_ httpBody:Data?) -> Self
    func addHTTPHeaderFields(_ httpHeaderFields: [String:String]) -> Self
    func build() -> URLRequest?
    
}

class NetworkInteractionsManager {
    
    struct URLEndPoints {
        static let baseURL: String =
        "https://itunes.apple.com/"
        
        struct Paths {
            static let search: String =
            "search"
        }
    }
    
    class URLBuilder: URLBuilderInterface {
        private(set) var pathComponents: [String] = []
        private(set) var queries: [URLQueryItem] = []
        private(set) var baseUrl: String = URLEndPoints.baseURL
        private(set) var percentEncodedUrl: String = ""
        private(set) var url: URL? = nil
    }
    
    class URLRequestBuilder: URLRequestBuilderInterface {
        private(set) var requestUrl: URL? = nil
        private(set) var httpMethod: String = HTTPMethod.get.rawValue
        private(set) var httpBody: Data?
        private(set) var allHTTPHeaderFields: [String:String] = [:]
    }
    
    let urlBuilder: URLBuilder
    let urlRequestBuilder: URLRequestBuilder
    init() {
        self.urlBuilder = URLBuilder()
        self.urlRequestBuilder = URLRequestBuilder()
    }
    
}

//MARK: URLBuilderInterface
extension NetworkInteractionsManager.URLBuilder
{
    func baseUrl(_ baseUrl:String) -> Self {
        self.baseUrl = baseUrl
        return self
    }
    
    func addQueries(_ queries: [String:String]) -> Self {
        
        let queryItems: [URLQueryItem] =
            queries.map { (pair:(key: String, value: String)) -> URLQueryItem in
                return URLQueryItem(name: pair.key, value: pair.value)
        }
  
        self.queries = queryItems
        return self
  
    }
    
    func addPathComponents(_ components: [String]) -> Self {
        self.pathComponents = components
        return self
    }
    
    func applyPercentEncoding() -> Self {
        return self
    }
    
    func build() -> URL? {
    
        guard var urlComponents: URLComponents =
            URLComponents(string: self.baseUrl) else {
                return nil
        }
        
        let path: String =
            self.makePath(from: self.pathComponents)
        
        urlComponents.path =
        path

        urlComponents.queryItems =
        self.queries
        
        let url: URL? =
        urlComponents.url
        
        self.url =
        url
        
        return url
    }
    
    private func makePath(from components: [String]) -> String {
        
        let path =
            components.reduce("/") { (result:String, next:String) -> String in
                return (result as NSString).appendingPathComponent(next)
        }
        
        return path
    }

}

extension NetworkInteractionsManager.URLRequestBuilder
{
    func requestUrl(_ requestUrl:URL) -> Self
    {
        self.requestUrl = requestUrl
        return self
    }
    
    func requestType(_ httpMethod:String) -> Self
    {
        self.httpMethod = httpMethod
        return self
    }
    
    func addBody(_ httpBody: Data?) -> Self {
        self.httpBody = httpBody
        return self
    }
    
    func addHTTPHeaderFields(_ httpHeaderFields: [String:String]) -> Self {
        self.allHTTPHeaderFields = httpHeaderFields
        return self
    }
    
    func build() -> URLRequest? {
        
        guard let requestUrl = self.requestUrl else {
            return nil
        }
        
        var urlRequest =
        URLRequest.init(url: requestUrl)
        
        urlRequest.httpMethod =
            self.httpMethod
            
        urlRequest.httpBody =
            self.httpBody
        
        urlRequest.allHTTPHeaderFields =
            self.allHTTPHeaderFields
        
        return urlRequest
    }
    
    
}


//MARK: Helpers
extension NetworkInteractionsManager
{
    func search(query: [String:String])
    {
        guard let searchURL =
        self.urlBuilder
            .baseUrl(NetworkInteractionsManager.URLEndPoints.baseURL)
            .addPathComponents([NetworkInteractionsManager.URLEndPoints.Paths.search])
            .addQueries(query)
            .build()
            else {
                return
        }
        
        let searchRequest: URLRequest? =
        self.urlRequestBuilder
            .requestUrl(searchURL)
            .build()
        
    }
    
}