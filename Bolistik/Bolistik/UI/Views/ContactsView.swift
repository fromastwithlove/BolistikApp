//
//  ContactsView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 25.12.24.
//

import SwiftUI

struct ContactsView: View {

    @StateObject var model: ContactsViewModel

    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                if model.contacts.isEmpty {
                    ContactsEmptyView()
                } else {
                    List($model.contacts) { $contact in
                        ContactRow(contact: $contact)
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $model.searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // Add friend
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                    .tint(.secondaryRed)
                }
            }
        }
    }
}

#Preview {
    ContactsView(model: ContactsViewModel())
}
