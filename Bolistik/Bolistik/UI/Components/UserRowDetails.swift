//
//  UserRowDetails.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 28.12.24.
//

import SwiftUI

struct UserRowDetails: View {
    
    @EnvironmentObject private var appManager: AppManager
    
    let geometry: GeometryProxy
    let avatarPath: String?
    let displayName: String
    let email: String
    
    var body: some View {
        HStack {
            if let path = avatarPath, !path.isEmpty {
                // Avatar Image
                ImageView(model: ImageViewModel(firebaseStorageService: appManager.services.firebaseStorageService,
                                                imagePath: path)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: min(geometry.size.width * 0.2, 90),
                               height: min(geometry.size.width * 0.2, 90))
                        .clipShape(.circle)
                        .clipped()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .frame(width: min(geometry.size.width * 0.2, 90),
                               height: min(geometry.size.width * 0.2, 90))
                        .opacity(0.5)
                        .symbolEffect(.bounce.down.wholeSymbol)
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
        UserRowDetails(geometry: geometry,
                       avatarPath: avatarPath,
                       displayName: displayName,
                       email: email)
    }
}
