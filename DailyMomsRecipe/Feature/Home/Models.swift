//
//  Models.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 19/04/22.
//

import Foundation

// MARK: - RestoData
struct RestoData: Codable {
    let categories: [Category]
    let list: [List]
}

// MARK: - Category
struct Category: Codable,Hashable {
    let id, name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
      lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

// MARK: - List
struct List: Codable {
    let categoryID: String
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case items
    }
}

// MARK: - Item
struct Item: Codable, Hashable {
    let id: String
    let price, displayPrice: Double
    let isDiscount: Bool
    let discountPercent: Int
    let imageURL: String
    let name, itemDescription: String
    let tags: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
      lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case price
        case displayPrice = "display_price"
        case isDiscount = "is_discount"
        case discountPercent = "discount_percent"
        case imageURL = "image_url"
        case name
        case itemDescription = "description"
        case tags
    }
}
