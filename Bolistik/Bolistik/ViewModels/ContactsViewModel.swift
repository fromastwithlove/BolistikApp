//
//  ContactsViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 26.12.24.
//

import Foundation

@MainActor
@Observable
final class ContactsViewModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "UI.ContactsViewModel")
    
    // MARK: - Published Properties
    
    var searchText: String = ""
    var contacts: [Contact] = Contact.samples
}
