//
//  Product.swift
//  avitotech-assignment
//
//  Created by Archichil on 12.02.25.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let images: [String]
}

let ProductMockData: [Product] = [
    Product(
        id: 36,
        title: "Rainbow Glitter High Heels",
        price: 39,
        description: "Step",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "https://i.imgur.com/62gGzeF.jpeg",
            "https://i.imgur.com/5MoPuFM.jpeg",
            "https://i.imgur.com/sUVj7pK.jpeg"
        ]
    ),
    Product(
        id: 37,
        title: "Chic Summer Denim Espadrille Sandals",
        price: 33,
        description: "Step into ",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "https://i.imgur.com/9qrmE1b.jpeg",
            "https://i.imgur.com/wqKxBVH.jpeg",
            "https://i.imgur.com/sWSV6DK.jpeg"
        ]
    ),
    Product(
        id: 38,
        title: "45t34",
        price: 90,
        description: "34",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "[\"https://api.escuelajs.co/api/v1/files/57ed.jpg\"]"
        ]
    ),
    Product(
        id: 39,
        title: "Vibrant Pink Classic Sneakers",
        price: 84,
        description: "saddss",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "https://i.imgur.com/mcW42Gi.jpeg",
            "https://i.imgur.com/mhn7qsF.jpeg",
            "https://i.imgur.com/F8vhnFJ.jpeg"
        ]
    ),
    Product(
        id: 41,
        title: "Futuristic Chic High-Heel Boots",
        price: 36,
        description: "Elevate",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "https://i.imgur.com/HqYqLnW.jpeg",
            "https://i.imgur.com/RlDGnZw.jpeg",
            "https://i.imgur.com/qa0O6fg.jpeg"
        ]
    ),
    Product(
        id: 42,
        title: "Elegant Patent Leather Peep-Toe Pumps with Gold-Tone Heel",
        price: 53,
        description: "Step into sophistication ",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "https://i.imgur.com/AzAY4Ed.jpeg",
            "https://i.imgur.com/umfnS9P.jpeg",
            "https://i.imgur.com/uFyuvLg.jpeg"
        ]
    ),
    Product(
        id: 43,
        title: "Elegant Purple Leather Loafers",
        price: 17,
        description: "Step into sophistication with ou",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "https://i.imgur.com/Au8J9sX.jpeg",
            "https://i.imgur.com/gdr8BW2.jpeg",
            "https://i.imgur.com/KDCZxnJ.jpeg"
        ]
    ),
    Product(
        id: 44,
        title: "Classic Blue Suede Casual Shoes",
        price: 39,
        description: "Step into comfort ",
        category: Category(id: 4, name: "Shoes", image: "https://i.imgur.com/qNOjJje.jpeg"),
        images: [
            "https://i.imgur.com/sC0ztOB.jpeg",
            "https://i.imgur.com/Jf9DL9R.jpeg",
            "https://i.imgur.com/R1IN95T.jpeg"
        ]
    ),
    Product(
        id: 45,
        title: "Sleek Futuristic Electric Bicycle",
        price: 22,
        description: "This modern ",
        category: Category(id: 5, name: "Miscellaneous", image: "https://i.imgur.com/BG8J0Fj.jpg"),
        images: [
            "https://i.imgur.com/BG8J0Fj.jpg",
            "https://i.imgur.com/ujHBpCX.jpg",
            "https://i.imgur.com/WHeVL9H.jpg"
        ]
    ),
    Product(
        id: 46,
        title: "Sleek All-Terrain Go-Kart",
        price: 37,
        description: "Experience",
        category: Category(id: 5, name: "Miscellaneous", image: "https://i.imgur.com/BG8J0Fj.jpg"),
        images: [
            "https://i.imgur.com/Ex5x3IU.jpg",
            "https://i.imgur.com/z7wAQwe.jpg",
            "https://i.imgur.com/kc0Dj9S.jpg"
        ]
    )
]
