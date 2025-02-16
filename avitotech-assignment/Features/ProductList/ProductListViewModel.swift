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
    
    @Published var searchHistory: [SearchSettings] = [] {
        didSet { saveSearchHistory() }
    }
    
    private let apiClient: APIClient
    private let searchHistoryKey = "searchHistory"
    private let currentSearchTextKey = "currentSearchText"
    private let currentSearchFiltersKey = "currentSearchFilters"
    
    private let limit = 10
    private var offset = 0

    init(apiClient: APIClient = FakeStoreAPIClient()) {
        self.apiClient = apiClient
        loadSearchHistory()
        loadCurrentSearchSettings()
    }
    
    @MainActor
    func loadProducts(reset: Bool = false) async {
        
        if reset {
            saveCurrentSearchSettings()
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
                recordSearchHistoryIfNeeded()
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
        
        // MARK: - History Persistence
    
    private func saveSearchHistory() {
        if let data = try? JSONEncoder().encode(searchHistory) {
            UserDefaults.standard.set(data, forKey: searchHistoryKey)
        }
    }
    
    private func loadSearchHistory() {
        if let data = UserDefaults.standard.data(forKey: searchHistoryKey),
           let history = try? JSONDecoder().decode([SearchSettings].self, from: data) {
            self.searchHistory = history
        }
    }
    
    private func saveCurrentSearchSettings() {
        UserDefaults.standard.set(searchText, forKey: currentSearchTextKey)
        if let data = try? JSONEncoder().encode(appliedFilters) {
            UserDefaults.standard.set(data, forKey: currentSearchFiltersKey)
        }
    }
    
    private func loadCurrentSearchSettings() {
        if let text = UserDefaults.standard.string(forKey: currentSearchTextKey) {
            self.searchText = text
        }
        if let data = UserDefaults.standard.data(forKey: currentSearchFiltersKey),
           let filters = try? JSONDecoder().decode([String: String].self, from: data) {
            self.appliedFilters = filters
        }
    }
    
    @MainActor
    func recordSearchHistoryIfNeeded() {
        guard !searchText.isEmpty else { return }
        let currentSettings = SearchSettings(text: searchText, filters: appliedFilters)
        if !searchHistory.contains(currentSettings) {
            searchHistory.insert(currentSettings, at: 0)
            if searchHistory.count > 5 {
                searchHistory = Array(searchHistory.prefix(5))
            }
        }
    }
}
