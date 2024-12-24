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
    
    init(appConfiguration: AppConfiguration, networkService: NetworkService, accountService: AccountService) {
        self.appConfiguration = appConfiguration
        self.networkService = networkService
        self.accountService = accountService
    }
}
