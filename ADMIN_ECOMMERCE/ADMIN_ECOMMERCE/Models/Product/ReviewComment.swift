//
//  ReviewComment.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import Foundation

struct RevỉewComment: Decodable {
    var success: Bool?
    var list: [Comment]?
    var averageReview: Double?
}
struct Comment: Decodable {
    var comment: String?
    var rating: Double?
    var createAt: String?
    var image: String?
    var userName: String?
}
