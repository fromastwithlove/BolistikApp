//
//  AppConfiguration.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 08.12.24.
//

final class AppConfiguration {
    /// The name of the app as shown in the UI
    let appName: String = "Bolistik"
    
    /// The list of server URLs, the first element is considered the default URL.
    let serverURLs: [String] = ["https://bolistik.kz",
                                "https://staging.bolistik.kz"]
}
