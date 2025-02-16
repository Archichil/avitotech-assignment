//
//  CartView.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartManager = CartManager.shared

    var body: some View {
        NavigationStack {
            List {
                ForEach(cartManager.items) { item in
                    NavigationLink(destination: ProductDetailView(product: item.product)) {
                        HStack {
                            AsyncImage(url: URL(string: item.product.images.first ?? "")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                } else if phase.error != nil {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                } else {
                                    ProgressView().frame(width: 50, height: 50)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(item.product.title)
                                Text("$\(item.product.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Stepper("\(item.quantity)", value: Binding(
                                get: { item.quantity },
                                set: { newValue in
                                    cartManager.update(product: item.product, quantity: newValue)
                                }
                            ), in: 1...99)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .onDelete { indices in
                    indices.forEach { index in
                        let item = cartManager.items[index]
                        cartManager.remove(product: item.product)
                    }
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") { cartManager.clear() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: shareCart) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    private func shareCart() {
        let cartText = cartManager.items
            .map { "\($0.product.title) x\($0.quantity) - $\($0.product.price)" }
            .joined(separator: "\n")
        let activityVC = UIActivityViewController(activityItems: [cartText], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
