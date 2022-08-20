//
//  ListDiscount.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 19/08/2022.
//

import Foundation

struct ListDiscount: Decodable {
    var success: Bool?
    var discounts: [DiscountItem]?
}

struct DiscountItem: Decodable {
    var createAt: String?
    var _id: String?
    var name: String?
    var categoryProduct: String?
    var validDate: String?
    var quantity: Int?
    var value: Int?
    var used: Bool?
    var userId: String?
}
