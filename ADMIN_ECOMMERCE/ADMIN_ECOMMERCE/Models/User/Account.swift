//
//  Account.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//

import Foundation

struct Account: Decodable {
    var success: Bool?
    var token: String?
    var user: User?
}

struct User: Decodable {
    var role: String?
    var _id: String?
    var email: String?
    var password: String?
//    var cart: [Cart]?
//    var discounts: [Discount]?
}

//struct Discount: Decodable {
//    var _id: String?
//}
