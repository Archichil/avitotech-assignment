//
//  CartItem.swift
//  avitotech-assignment
//
//  Created by Archichil on 16.02.25.
//

import Foundation

struct CartItem: Identifiable, Codable {
    var id: UUID = UUID()
    let product: Product
    var quantity: Int
}
