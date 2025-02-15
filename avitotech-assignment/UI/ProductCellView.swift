//
//  ProductCellView.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading) {
            ProductImageView(url: product.images.first ?? "")
            Text(product.title)
                .font(.callout)
                .lineLimit(2)
                .frame(minHeight: 40, alignment: .top)
            Text("$\(product.price, specifier: "%.2f")")
                .font(.title3)
                .bold()
        }
        .frame(width: 175)
    }
}

#Preview {
    ProductCellView(product: ProductMockData.first!)
}
