//
//  Services.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

actor Services {
    
    let appConfiguration: AppConfiguration
    let networkService: NetworkService
    let authenticationService: AuthenticationService
    let firestoreService: FirestoreService
    
    init() {
        self.appConfiguration = AppConfiguration()
        self.networkService = NetworkService(defaultBaseURLString: appConfiguration.serverURLs.first!)
        self.authenticationService = AuthenticationService(firebaseAuthService: FirebaseAuthService(), firestoreService: FirestoreService())
        self.firestoreService = FirestoreService()
    }
}
