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
    
    // MARK: - Private
    
    private let logger = AppLogger(category: "UI.ContactsViewModel")
    
    // MARK: - Published properties
    
    var searchText: String = ""
    
    var contacts: [Contact] = Contact.samples
    
    // MARK: - Public
}
