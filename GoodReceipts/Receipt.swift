//
//  Receipt.swift
//  GoodReceipts
//
//  Created by Nadya Postriganova on 27/12/19.
//  Copyright © 2019 Nadya Postriganova. All rights reserved.
//

import Foundation

struct Receipt: Codable {
    var id: String?
    var number: String
    var purchaseItems: [String]?
    var purchaseDate: Date?
    var merchant: String?
    var price: Int
}
