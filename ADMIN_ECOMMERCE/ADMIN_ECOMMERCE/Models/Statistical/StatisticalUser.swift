//
//  StatisticalUser.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 14/08/2022.
//

import Foundation


struct Statistical: Decodable {
    var data: DataStatistical?
}

struct DataStatistical: Decodable {
    var labels: [String]?
    var datasets: [Datasets]?
}

struct Datasets: Decodable {
    var label: String?
    var data: [Float]?
    var fill: Bool?
}
