//
//  Category.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import Foundation

struct Category: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let image: String
}
