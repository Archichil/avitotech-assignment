//
//  FiltersView.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import SwiftUI

struct FiltersView: View {
    @StateObject var viewModel = FiltersViewModel()
    @Binding var appliedFilters: [String: String]
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: String = ""
    @State private var minPrice: String = ""
    @State private var maxPrice: String = ""
    @State private var price: String = ""
    
    let onApply: () -> Void
    
    init(appliedFilters: Binding<[String: String]>, onApply: @escaping () -> Void) {
        self._appliedFilters = appliedFilters
        self.onApply = onApply
        let filters = appliedFilters.wrappedValue
        _selectedCategory = State(initialValue: filters["categoryId"] ?? "")
        _minPrice = State(initialValue: filters["price_min"] ?? "")
        _maxPrice = State(initialValue: filters["price_max"] ?? "")
        _price = State(initialValue: filters["price"] ?? "")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Category")) {
                        Picker("Category", selection: $selectedCategory) {
                            Text("All").tag("")
                            ForEach(viewModel.categories) { category in
                                Text(category.name).tag(String(category.id))
                            }
                        }
                        .onAppear {
                            Task {
                                await viewModel.loadCategories()
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    Section(header: Text("Price Range")) {
                        TextField("Min price", text: $minPrice)
                            .keyboardType(.decimalPad)
                        TextField("Max price", text: $maxPrice)
                            .keyboardType(.decimalPad)
                    }
                    Section(header: Text("Exact Price")) {
                        TextField("Exact price", text: $price)
                            .keyboardType(.decimalPad)
                    }
                }

                Button(action: {
                    var filters: [String: String] = [:]
                    if !selectedCategory.isEmpty {
                        filters["categoryId"] = selectedCategory
                    }
                    if !minPrice.isEmpty {
                        filters["price_min"] = minPrice
                    }
                    if !maxPrice.isEmpty {
                        filters["price_max"] = maxPrice
                    }
                    if !price.isEmpty {
                        filters["price"] = price
                    }
                    print("[DEBUG] Applied filters: \(filters)")
                    appliedFilters = filters
                    onApply()
                    dismiss()
                }) {
                    Text("Apply")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .padding([.horizontal, .bottom])
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15))
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Clear") {
                        selectedCategory = ""
                        minPrice = ""
                        maxPrice = ""
                        price = ""
                    }
                }
            }
        }
    }
}
