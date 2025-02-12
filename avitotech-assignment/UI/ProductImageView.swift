//
//  ProductImageView.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import SwiftUI

struct ProductImageView: View {
    let url: String
    private let imageHeight: CGFloat = 175
    private let imageWidth: CGFloat = 175

    // TODO: Extract view modifiers
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            case .empty:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .shimmeringPlaceholder()
            @unknown default:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .shimmeringPlaceholder()
            }
        }
        .cornerRadius(8)
        .frame(width: imageWidth, height: imageHeight)
    }
}

#Preview {
    ProductImageView(url: "https://i.imgur.com/62gGzeF.jpeg")
}
