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

protocol NetworkService {
    func request<T: Decodable, U: Encodable>(
        url: URL,
        method: HttpMethod,
        payload: U?,
        headers: [String: String]?
    ) -> AnyPublisher<T, Error>
}
