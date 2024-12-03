//
//  NetworkManager.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Foundation
import Combine

class NetworkManager: NetworkService {
    
    func request<T: Decodable, U: Encodable>(
        url: URL,
        method: HttpMethod = .get,
        payload: U? = nil,
        headers: [String: String]? = nil
    ) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let payload = payload {
            do {
                request.httpBody = try JSONEncoder().encode(payload)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
