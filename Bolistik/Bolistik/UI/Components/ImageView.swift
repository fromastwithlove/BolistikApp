//
//  ImageView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 11.03.25.
//

import SwiftUI

struct ImageView<I, P>: View where I: View, P: View {
    
    @StateObject var model: ImageViewModel
    let content: (Image) -> I
    let placeholder: () -> P
    
    var body: some View {
        Group {
            switch model.imageState {
            case .empty:
                placeholder()
            case .loading:
                ProgressView()
            case .success(let image):
                content(image)
            case .failure(let error):
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                    Text("Error: \(error.localizedDescription)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .task {
            await model.loadImage()
        }
    }
}
