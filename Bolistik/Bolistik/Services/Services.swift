//
//  Services.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

actor Services {
    
    let appConfiguration: AppConfiguration
    let networkService: NetworkService
    let accountService: AccountService
    
    init() {
        self.appConfiguration = AppConfiguration()
        self.networkService = NetworkService(defaultBaseURLString: appConfiguration.serverURLs.first!)
        self.accountService = AccountService(firebaseAuthService: FirebaseAuthService())
    }
}
