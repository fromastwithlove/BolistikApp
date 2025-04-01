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
                placeholder()
            case .success(let image):
                content(image.resizable())
            case .failure(let error):
                VStack {
                    Text("Error: \(error.localizedDescription)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.yellow)
                }
            }
        }
        .task {
            await model.loadImage()
        }
    }
}
