//
//  ContactRowDetails.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.12.24.
//

import SwiftUI

struct ContactRowDetails: View {
    
    @EnvironmentObject private var appManager: AppManager
    @Environment(\.dependencies) private var dependencies
    
    let geometry: GeometryProxy
    let avatarPath: String?
    let displayName: String
    let email: String
    
    var body: some View {
        HStack {
            if let avatarPath, !avatarPath.isEmpty {
                // Avatar Image
                ImageView(model: ImageViewModel(storageService: dependencies.storageService,
                                                imagePath: avatarPath)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: min(geometry.size.width * 0.2, 90),
                               height: min(geometry.size.width * 0.2, 90))
                        .clipShape(.circle)
                        .clipped()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: min(geometry.size.width * 0.2, 90),
                               height: min(geometry.size.width * 0.2, 90))
                        .opacity(0.5)
                }
            }

            // Full name
            VStack(alignment: .leading) {
                Text(displayName)
                    .font(.headline)
                Text(email)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    @Previewable @State var avatarPath: String = "public/alan.turing.jpg"
    @Previewable @State var displayName: String = "Alan Turing"
    @Previewable @State var email: String = "alan.turing@bolistik.kz"
    GeometryReader { geometry in
        ContactRowDetails(geometry: geometry,
                       avatarPath: avatarPath,
                       displayName: displayName,
                       email: email)
    }
}
