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
struct List: Codable, Hashable {
    let categoryID: String
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(categoryID)
    }
    
    static func == (lhs: List, rhs: List) -> Bool {
        lhs.categoryID == rhs.categoryID
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

extension Category{
    static var allCategory:[Category] = [Category(id: "popular", name: "Popular"),
                                         Category(id: "appetizer", name: "Appetizer"),
                                         Category(id: "main_course", name: "Main Course"),
                                         Category(id: "dessert", name: "Dessert"),
                                         Category(id: "beverages", name: "Beverages"),
    ]
    
    static func getSingleCategory(id :String) -> Category?{
        let index = allCategory.firstIndex{ $0.id == id }
        guard let finalIndex = index?.toInt else {
            return nil
        }
        return allCategory[finalIndex]
    }
}

extension List{
    static var allList :[List] = [
        List(categoryID: "popular", items: [(Item(id: "6176686afc13ae4e76000000", price: 1.5, displayPrice: 1.5, isDiscount: false, discountPercent: 0, imageURL: "https://picsum.photos/id/0/5616/3744", name: "Nectarine and beetroot salad", itemDescription: "A crisp salad featuring fresh nectarine and beetroot", tags: [
            "white_cabbage",
            "lettuce",
            "tomato",
            "nectarine",
            "beetroot"
        ])),
        (Item(id: "6176686afc13ae4e76000001", price: 1.5, displayPrice: 1.5, isDiscount: false, discountPercent: 0, imageURL: "https://picsum.photos/id/0/5616/3744", name: "Nectarine and beetroot salad", itemDescription: "A crisp salad featuring fresh nectarine and beetroot", tags: [
                                                "white_cabbage",
                                                "lettuce",
                                                "tomato",
                                                "nectarine",
                                                "beetroot"
                                            ])),
        (Item(id: "6176686afc13ae4e76000020", price: 1.5, displayPrice: 1.5, isDiscount: false, discountPercent: 0, imageURL: "https://picsum.photos/id/0/5616/3744", name: "Nectarine and beetroot salad", itemDescription: "A crisp salad featuring fresh nectarine and beetroot", tags: [
                                                "white_cabbage",
                                                "lettuce",
                                                "tomato",
                                                "nectarine",
                                                "beetroot"
                                            ]))]),
        List(categoryID: "dessert", items: [(Item(id: "6176686afc13ae4e76000002", price: 8, displayPrice: 4, isDiscount: true, discountPercent: 50, imageURL: "https://picsum.photos/id/10/2500/1667", name: "Italian seasoning and potato starch salad", itemDescription: "Italian seasoning and potato starch served on a bed of lettuce", tags: [
            "lettuce",
            "italian_seasoning",
            "potato_starch"
        ])),
        (Item(id: "6176686afc13ae4e76000042", price: 8, displayPrice: 4, isDiscount: true, discountPercent: 50, imageURL: "https://picsum.photos/id/10/2500/1667", name: "Italian seasoning and potato starch salad", itemDescription: "Italian seasoning and potato starch served on a bed of lettuce", tags: [
                                                "lettuce",
                                                "italian_seasoning",
                                                "potato_starch"
                                            ])),
        (Item(id: "6176686afc13ae4e76000052", price: 8, displayPrice: 4, isDiscount: true, discountPercent: 50, imageURL: "https://picsum.photos/id/10/2500/1667", name: "Italian seasoning and potato starch salad", itemDescription: "Italian seasoning and potato starch served on a bed of lettuce", tags: [
                                                                                    "lettuce",
                                                                                    "italian_seasoning",
                                                                                    "potato_starch"
                                                                                ]))
                                           ]),
        List(categoryID: "beverages", items: [(Item(id: "6176686afc13ae4e76000002", price: 8, displayPrice: 4, isDiscount: true, discountPercent: 50, imageURL: "https://picsum.photos/id/10/2500/1667", name: "Italian seasoning and potato starch salad", itemDescription: "Italian seasoning and potato starch served on a bed of lettuce", tags: [
            "lettuce",
            "italian_seasoning",
            "potato_starch"
        ])),
        (Item(id: "6176686afc13ae4e7600002", price: 8, displayPrice: 4, isDiscount: true, discountPercent: 50, imageURL: "https://picsum.photos/id/10/2500/1667", name: "Italian seasoning and potato starch salad", itemDescription: "Italian seasoning and potato starch served on a bed of lettuce", tags: [
                                                "lettuce",
                                                "italian_seasoning",
                                                "potato_starch"
                                            ])),
        (Item(id: "6176686afc13ae4e7600003", price: 8, displayPrice: 4, isDiscount: true, discountPercent: 50, imageURL: "https://picsum.photos/id/10/2500/1667", name: "Italian seasoning and potato starch salad", itemDescription: "Italian seasoning and potato starch served on a bed of lettuce", tags: [
                                                                                    "lettuce",
                                                                                    "italian_seasoning",
                                                                                    "potato_starch"
                                                                                ]))
                                           ])
    ]
}
