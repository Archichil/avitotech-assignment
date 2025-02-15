//
//  APIClient.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import Foundation

protocol APIClient {
    func fetchProducts(offset: Int, limit: Int, search: String?, filters: [String: String]?) async throws -> [Product]
    func fetchCategories() async throws -> [Category]
}

struct FakeStoreAPIClient: APIClient {
    private let baseURL = "http://165.227.238.45:3001/api/v1"
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()

    func fetchProducts(offset: Int, limit: Int, search: String?, filters: [String: String]?) async throws -> [Product] {
        print("[DEBUG] Fetching with offset \(offset)")
        var urlComponents = URLComponents(string: "\(baseURL)/products")!
        var queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        if let search = search, !search.isEmpty {
            queryItems.append(URLQueryItem(name: "title", value: search))
        }
        if let filters = filters {
            for (key, value) in filters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        urlComponents.queryItems = queryItems
        
        let url = urlComponents.url!
        print("[DEBUG] Request URL: \(url)")
        let (data, _) = try await urlSession.data(from: url)
        return try jsonDecoder.decode([Product].self, from: data)
    }
    
    func fetchCategories() async throws -> [Category] {
        let url = URL(string: baseURL + "/categories")!
        let (data, _) = try await urlSession.data(from: url)
        
        return try jsonDecoder.decode([Category].self, from: data)
    }
}

