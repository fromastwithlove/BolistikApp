//
//  NetworkService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation
import Combine

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

actor NetworkService {
    
    // MARK: Private
    
    private let logger = AppLogger(category: "Networking")
    
    private let baseURLString: String
    private let userDefaults = UserDefaults()
    
    private var session: URLSession {
        // Use the ephemeral session so it doesn't download or cache anything.
        let config: URLSessionConfiguration = .ephemeral
        
        // Cookie policy
        config.httpCookieAcceptPolicy = .never
        config.httpCookieStorage = nil
        config.httpShouldSetCookies = false
        
        return URLSession(configuration: config)
    }
    
    // MARK: Public
    
    init(baseURLString: String) {
        self.baseURLString = baseURLString
    }
}
