//
//  ProductListViewModel.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import Foundation

final class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    @Published var appliedFilters: [String: String] = [:]
    @Published var hasMoreProducts = true
    @Published var initialLoadCompleted = false
    
    private var offset = 0
    private let limit = 10
    private let apiClient: APIClient

    init(apiClient: APIClient = FakeStoreAPIClient()) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func loadProducts(reset: Bool = false) async {
        
        if reset {
            offset = 0
            products.removeAll()
            hasMoreProducts = true
            initialLoadCompleted = false
        }

        guard hasMoreProducts || reset else { return }
        
        isLoading = true
        do {
            let newProducts = try await apiClient.fetchProducts(offset: offset, limit: limit, search: searchText, filters: appliedFilters)
            
            // Stop unnessesary loading if made it to the end
            if !newProducts.isEmpty {
                products.append(contentsOf: newProducts)
                offset += limit
            } else {
                hasMoreProducts = false
            }
            
            initialLoadCompleted = true
            error = nil
        } catch {
            self.error = error
            print("[DEBUG] FetchProducts failed. Error: \(error.localizedDescription)")
        }
        isLoading = false
    }
}
