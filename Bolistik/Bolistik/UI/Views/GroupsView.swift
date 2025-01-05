//
//  GroupsView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 04.01.25.
//

import SwiftUI

struct GroupsView: View {
    
    @StateObject var model: ExpenseGroupViewModel
    
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                if model.groups.isEmpty {
                    GroupsEmptyView()
                } else {
                    List($model.groups) { $group in
                        GroupRow(group: $group)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // Create group
                    } label: {
                        Image(systemName: "person.2.badge.plus")
                    }
                    .tint(.secondaryRed)
                }
            }
        }
    }
}

#Preview {
    GroupsView(model: ExpenseGroupViewModel())
}
