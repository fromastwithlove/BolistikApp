//
//  Services.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

actor Services {
    
    let appConfiguration: AppConfiguration
    let networkService: NetworkService
    let userService: UserService
    
    init(appConfiguration: AppConfiguration, networkService: NetworkService, userService: UserService) {
        self.appConfiguration = appConfiguration
        self.networkService = networkService
        self.userService = userService
    }
}
