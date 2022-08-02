//
//  ListProduct.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import Foundation

struct ExploreProducts: Decodable {
    var success: Bool?
    var products: [Product]?
}

struct Product: Decodable {
    var __v: Int?
    var price: Double?
    var _id: String?
    var name: String?
    var description: String?
    var classify: String?
    var category: String?
    var stock: Int?
    var images: [Image]?
    var user: String?
    var seller: String?
    var createdAt: String?
    var reviews: [Review]?
    var updateStock: [upStock]?
}

struct Image: Decodable {
    var _id: String?
    var url: String?
    var public_id: String?
}

struct Review: Decodable {
    var createAt: String?
    var _id: String?
    var rating: Double?
    var comment: String?
    var userId: String?
}

struct upStock: Decodable {
    var updateDate: String?
    var _id: String?
    var userId: String?
    var quantity: Int?
}
