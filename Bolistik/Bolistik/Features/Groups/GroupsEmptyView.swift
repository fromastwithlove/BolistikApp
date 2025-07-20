//
//  GroupsEmptyView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 04.01.25.
//

import SwiftUI

struct GroupsEmptyView: View {
    var body: some View {
        VStack {
            Image("CreateGroup")
                .resizable()
                .scaledToFit()
                .padding(.vertical)
            
            Text("Gather Your Crew and Split the Costs!")
                .font(.title2)
                .foregroundStyle(.secondaryRed)
            
            Text("Create a group to start sharing and splitting expenses. Invite people you’re traveling with or living with, and keep track of all your bills together!")
                .font(.title3)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            Button {
                // Create a group
            } label: {
                Label("Start a group", systemImage: "person.2.badge.plus")
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
    GroupsEmptyView()
}
