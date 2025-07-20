//
//  AppDependencies.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 19.07.25.
//

protocol AppDependenciesProtocol {
    var firestoreService: FirestoreServiceProtocol { get }
    var storageService: FirebaseStorageServiceProtocol { get }
    var authService: AuthenticationServiceProtocol { get }
}

struct AppDependencies: AppDependenciesProtocol {
    let authService: AuthenticationServiceProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: FirebaseStorageServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.authService = AuthenticationService(firestoreService: firestoreService)
        self.firestoreService = firestoreService
        self.storageService = FirebaseStorageService()
    }
}
