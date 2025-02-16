//
//  ProductListView.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel = ProductListViewModel()
    @State private var isShowingFilters = false
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                if !viewModel.searchHistory.isEmpty {
                    Text("Latest searches")
                        .font(.caption)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.searchHistory, id: \.self) { history in
                                Button(action: {
                                    viewModel.searchText = history.text
                                    viewModel.appliedFilters = history.filters
                                    Task { await viewModel.loadProducts(reset: true) }
                                }) {
                                    if !history.filters.isEmpty {
                                        Text("\(history.text) (Filtered)")
                                            .padding(8)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                    } else {
                                        Text(history.text)
                                            .padding(8)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                contentView
                    .frame(maxHeight: .infinity, alignment: .center)
            }
            .task {
                if !viewModel.initialLoadCompleted {
                    await viewModel.loadProducts(reset: true)
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Search...", text: $viewModel.searchText)
                .padding()
                .frame(height: 45)
                .background(.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    HStack {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Label("clear", systemImage: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .opacity(viewModel.searchText.isEmpty ? 0 : 1)
                                .padding()
                        }
                        .labelStyle(.iconOnly)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .onSubmit {
                    Task { await viewModel.loadProducts(reset: true) }
                }
            
            Button(action: { isShowingFilters = true }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .font(.title)
            }
            .sheet(isPresented: $isShowingFilters) {
                FiltersView(appliedFilters: $viewModel.appliedFilters) {
                    Task { await viewModel.loadProducts(reset: true) }
                }
            }
        }
        .padding()
    }
        
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading && viewModel.products.isEmpty {
            Section {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(0..<4) { _ in
                        ShimmeringProductCellView()
                    }
                }
            }
        } else if let error = viewModel.error, viewModel.products.isEmpty {
            VStack {
                Text("Error: \(error.localizedDescription)")
                Button("Try Again") {
                    Task { await viewModel.loadProducts(reset: true) }
                }
            }
        } else if viewModel.products.isEmpty {
            Text("Nothing found :(")
        } else {
            productsGrid
        }
    }
    
    private var productsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.products) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCellView(product: product)
                            .onAppear {
                                if product == viewModel.products.last,
                                   viewModel.hasMoreProducts,
                                   !viewModel.isLoading {
                                    Task { await viewModel.loadProducts() }
                                }
                            }
                    }
                    .navigationTitle("")
                    .buttonStyle(.plain)
                }
            }
            .padding()
            if viewModel.isLoading {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(0..<10) { _ in
                        ShimmeringProductCellView()
                    }
                }
            }
        }
    }
}
