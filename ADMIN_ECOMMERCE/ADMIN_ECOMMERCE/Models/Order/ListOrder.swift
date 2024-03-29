//
//  ListOrder.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 31/07/2022.
//

import Foundation

struct ListOrder: Decodable {
    var success: Bool?
    var totalPayment: Double?
    var orders: [Order]?
}

struct Order: Decodable {
    var shippingInfo: ShippingInfo?
    var paymentMethod: String
    var itemsPrice: Double?
    var taxPrice: Double?
    var totalPrice: Double?
    var orderStatus: String?
    var _id: String?
    var orderItems: [OrderItem]?
    var user: String?
    var discount: Discount?
    var createAt: String?
}

struct ShippingInfo: Decodable {
    var address: String?
    var city: String?
    var phoneNo: String?
    var postalCode: String?
    var country: String?
}

struct OrderItem: Decodable {
    var price: Double?
    var name: String?
    var quantity: Int?
    var product: String?
    var image: String?
    
}

struct Discount: Decodable {
    var _id: String?
}
