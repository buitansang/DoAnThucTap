//
//  OrderByID.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 06/08/2022.
//

import Foundation

struct OrderByID: Decodable {
    var success: Bool?
    var order: OrderID?
}

struct OrderID: Decodable {
    var shippingInfo: ShippingInfo?
    var paymentMethod: String?
    var itemsPrice: Double?
    var taxPrice: Double?
    var shippingPrice: Double?
    var totalPrice: Double?
    var orderStatus: String?
    var _id: String?
    var orderItems: [OrderItem]
    var user: String?
}
