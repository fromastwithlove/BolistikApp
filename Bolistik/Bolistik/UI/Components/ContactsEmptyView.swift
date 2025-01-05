//
//  ContactsEmptyView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 29.12.24.
//

import SwiftUI

struct ContactsEmptyView: View {
    var body: some View {
        VStack {
            Image("AddFriend")
                .resizable()
                .scaledToFit()
                .padding(.vertical)
            
            Text("Oops, It's Lonely Here!")
                .font(.title2)
                .foregroundStyle(.secondaryRed)
            
            Text("Looks like you don’t have any friends yet. Go ahead, add some and make this place a party!")
                .font(.title3)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            Button {
                // Add friend
            } label: {
                Label("Add Friend", systemImage: "person.badge.plus")
                    .frame(maxWidth: .infinity)
                    .font(.title3)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.secondaryRed)
        }
        .padding()
        .shadow(radius: 10)
    }
}

#Preview {
    ContactsEmptyView()
}
