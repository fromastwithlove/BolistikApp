//
//  AppDependencies.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 19.07.25.
//

protocol AppDependenciesProtocol {
    var authService: AuthenticationServiceProtocol { get }
    var storageService: FirebaseStorageServiceProtocol { get }
    var profileRepository: ProfileRepositoryProtocol { get }
}

struct AppDependencies: AppDependenciesProtocol {
    
    let authService: AuthenticationServiceProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: FirebaseStorageServiceProtocol
    let profileRepository: ProfileRepositoryProtocol
    
    init(firestoreService: FirestoreServiceProtocol = FirestoreService(),
         storageService: FirebaseStorageServiceProtocol = FirebaseStorageService()) {
        self.authService = AuthenticationService(firestoreService: firestoreService)
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.profileRepository = ProfileRepository(firestoreService: firestoreService)
    }
}
