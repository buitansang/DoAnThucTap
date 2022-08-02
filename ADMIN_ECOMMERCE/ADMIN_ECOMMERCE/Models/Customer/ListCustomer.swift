//
//  ListCustomer.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import Foundation

struct ListCustomer: Decodable {
    var success: Bool?
    var users: [Customer]
}

struct Customer: Decodable {
    var avatar: Avatar?
    var createAt: String?
    var placeOfBirth: String?
    var dateOfBirth: String?
    var _id: String?
    var name: String?
    var phoneNumber: String?
    var emailUser: String?
}

