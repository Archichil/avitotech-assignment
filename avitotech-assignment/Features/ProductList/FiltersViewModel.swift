//
//  FiltersViewModel.swift
//  avitotech-assignment
//
//  Created by Archichil on 15.02.25.
//

import Foundation

final class FiltersViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = FakeStoreAPIClient()) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func loadCategories() async {
        isLoading = true
        do {
            let categories = try await apiClient.fetchCategories()
            
            if !categories.isEmpty {
                self.categories.append(contentsOf: categories)
            } else {
                print("[DEBUG] API Error: Caterories are empty.")
            }
        } catch {
            self.error = error
            print("[DEBUG] FetchCategories failed. Error: \(error.localizedDescription)")
        }
        isLoading = false
    }
}
