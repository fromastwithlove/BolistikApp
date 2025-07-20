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
    
    // MARK: - Private Properties
    
    private let logger = AppLogger(category: "UI.ExpenseGroupsViewModel")
    
    // MARK: - Published Properties
    
    var groups: [ExpenseGroup] = ExpenseGroup.samples
}
