//
//  AppConfiguration.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

public protocol AppConfiguration {
    /// The name of the app as shown in the UI
    var appName: String { get }
    
    /// The list of server URLs, the first element is considered the default URL.
    var serverURLs: [String] { get }
}

final class BolistikApplication: AppConfiguration {
    
    let appName: String = "Bolistik"
    
    let serverURLs: [String] = ["https://bolistik.kz",
                                "https://staging.bolistik.kz"]
}
