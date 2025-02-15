//
//  ShimmeringProductCellView.swift
//  avitotech-assignment
//
//  Created by Archichil on 13.02.25.
//

import SwiftUI

struct ShimmeringProductCellView: View {

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .shimmeringPlaceholder()
            Text("Some text to shimmer")
                .font(.callout)
                .lineLimit(2)
                .shimmeringPlaceholder()
            Text("some text")
                .font(.title3)
                .bold()
                .shimmeringPlaceholder()
        }
        .frame(width: 175)
    }
}

#Preview {
    ShimmeringProductCellView()
}

