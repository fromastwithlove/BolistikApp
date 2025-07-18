//
//  ExpenseGroupsViewModel.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 04.01.25.
//

import Foundation

@MainActor
@Observable
final class ExpenseGroupsViewModel: ObservableObject {
    
    // MARK: - Private
    
    private let logger = AppLogger(category: "UI.ExpenseGroupsViewModel")
    
    // MARK: - Published properties
    
    var groups: [ExpenseGroup] = ExpenseGroup.samples
    
    // MARK: - Public
}
