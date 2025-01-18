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
    
    init(appConfiguration: AppConfiguration, accountService: AccountService) {
        self.appConfiguration = appConfiguration
        self.networkService = NetworkService(baseURLString: appConfiguration.serverURLs.first!)
        self.accountService = accountService
    }
}
