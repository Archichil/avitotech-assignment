//
//  ProductDetailView.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import SwiftUI

struct ProductDetailView: View {
    
    let product: Product
    @State private var quantity: Int = 1
    @State private var isAddedToCart = false
    @State private var isShowingGallery = false
    @State private var currentImageIndex = 0
    @State private var showCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TabView(selection: $currentImageIndex) {
                    ForEach(product.images.indices, id: \.self) { index in
                        AsyncImage(url: URL(string: product.images[index])) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.gray)
                            } else {
                                ProgressView()
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)
                .onTapGesture { isShowingGallery.toggle() }
                
                // Product info
                VStack(alignment: .leading, spacing: 16) {
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title)
                        .bold()
                    Text(product.title)
                        .font(.title)
                    Text("Description")
                        .font(.title2)
                        .bold()
                    Text(product.description)
                        .font(.body)
                    Text("Category: \(product.category.name)")
                        .font(.headline)
                }
                .padding(.horizontal)
            
                // Add to cart
                if !isAddedToCart {
                    Button(action: addToCart) {
                        Text("Add to cart")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    HStack(spacing: 16) {
                        HStack(spacing: 8) {
                            Button(action: {
                                if quantity > 1 { quantity -= 1 }
                                CartManager.shared.update(product: product, quantity: quantity)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.title2)
                            }
                            
                            Text("\(quantity)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(minWidth: 50)
                            
                            Button(action: {
                                quantity += 1
                                CartManager.shared.update(product: product, quantity: quantity)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.title2)
                            }
                        }
                        
                        
                        Button(action: { showCart = true }) {
                            Text("Go to cart")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .navigationTitle(product.title)
        .fullScreenCover(isPresented: $isShowingGallery) {
            GalleryView(images: product.images, selectedIndex: currentImageIndex)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: shareProduct) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .background(
            NavigationLink(destination: CartView(), isActive: $showCart) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    private func shareProduct() {
        let shareText = """
                        Title: \(product.title)
                        Price: \(product.price)
                        Description: \(product.description)
                        Category: \(product.category.name)
                        """
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // Present VC on the main thread
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                rootVC.present(activityVC, animated: true, completion: nil)
            } else {
                print("[DEBUG] Failed to present share sheet: Root VC not found.")
            }
        }
    }
    
    private func addToCart() {
        if !isAddedToCart {
            CartManager.shared.add(product: product, quantity: quantity)
            isAddedToCart = true
        }
    }
}
