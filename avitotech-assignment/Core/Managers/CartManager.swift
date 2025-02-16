//
//  CartManager.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import Foundation

final class CartManager: ObservableObject {
    static let shared = CartManager()
    @Published private(set) var items: [CartItem] = []
    
    private let cartKey = "cartItems"

    private init() {
        loadCart()
    }
    
    func add(product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
        saveCart()
    }
    
    func remove(product: Product) {
        items.removeAll { $0.product.id == product.id }
        saveCart()
    }
    
    func update(product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity = quantity
            saveCart()
        }
    }
    
    func clear() {
        items.removeAll()
        saveCart()
    }
    
    private func saveCart() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: cartKey)
        } catch {
            print("Error saving cart: \(error.localizedDescription)")
        }
    }
    
    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: cartKey) {
            do {
                items = try JSONDecoder().decode([CartItem].self, from: data)
            } catch {
                print("Error loading cart: \(error.localizedDescription)")
            }
        }
    }
}
