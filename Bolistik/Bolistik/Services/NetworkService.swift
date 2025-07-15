//
//  NetworkService.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation
import Combine

actor NetworkService {
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "Network")
    
    private let defaultBaseURLString = ""
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
    
    private var apiBaseURLString: String {
        return baseURLString.appending("/api/v1")
    }
    
    // MARK: - Public Properties
    
    public var baseURLString: String {
        get {
            #if LOCAL_ENVIRONMENT
            return "http://192.168.178.28:3000"
            #else
            if let urlString = userDefaults.baseURL {
                return urlString
            }
            return defaultBaseURLString
            #endif
        }
        set {
            userDefaults.baseURL = newValue
        }
    }
    
    // MARK: - Requests
    
    func registerWithApple(identityToken: String, authorizationCode: String, timeout: TimeInterval = 30) async throws -> (Data, URLResponse) {
        logger.debug("Register in backend with Apple credentials started")
        
        guard let url = URL(string: apiBaseURLString)?.appending(path: "auth/oauth/apple") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "identityToken": identityToken,
            "authorizationCode": authorizationCode
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload)
            request.httpBody = jsonData
        } catch {
            logger.error("Request URL: \(url), error serializing JSON: \(error.localizedDescription)")
            throw error
        }
        
        request.timeoutInterval = timeout
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logger.error("Invalid response type: \(String(describing: response))")
                throw URLError(.badServerResponse)
            }
            
            if httpResponse.statusCode == 401 {
                self.logger.error("Request URL: \(url), unauthorized: \(httpResponse.statusCode)")
                throw URLError(.userAuthenticationRequired)
            }
            
            if httpResponse.statusCode != 201 {
                self.logger.error("Request URL: \(url), status code: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
            
            return (data, response)
        } catch {
            throw error
        }
    }
}
