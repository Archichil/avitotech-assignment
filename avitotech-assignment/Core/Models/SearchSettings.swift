//
//  SearchSettings.swift
//  avitotech-assignment
//
//  Created by Archichil on 16.02.25.
//

struct SearchSettings: Codable, Equatable, Hashable {
    let text: String
    let filters: [String: String]
}
