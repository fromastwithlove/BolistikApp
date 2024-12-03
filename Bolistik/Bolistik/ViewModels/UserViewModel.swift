//
//  UserViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 03.12.24.
//

import Combine
import Foundation

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkService = NetworkManager()) {
        self.networkService = networkService
    }
    
    func registerUser(email: String, username: String, identityToken: String) {
        guard let url = URL(string: "https://staging-bolistik.v6.army/register") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let payload = [
            "email": email,
            "username": username,
            "identityToken": identityToken
        ]
        
        networkService.request(url: url, method: .post, payload: payload, headers: ["Content-Type": "application/json"])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
            }, receiveValue: { (user: User) in
                self.currentUser = user
            })
            .store(in: &cancellables)
    }
}
