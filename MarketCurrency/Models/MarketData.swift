//
//  MarketData.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 03.09.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import Foundation

struct MarketData: Codable {
    
    var stock: [Stock]

    enum CodingKeys: String, CodingKey {
        case stock
    }
}

// MARK: - Stock
struct Stock: Codable {
    
    var name: String
    var price: Price
    var percentChange: Double
    var volume: Int
    var symbol: String
    var isFavorite: Bool {
        if DataManager.shared.dataDictonary[name] == true {
            return true
        }
        return false
    }

    enum CodingKeys: String, CodingKey {
        case name, price
        case percentChange = "percent_change"
        case volume, symbol
    }
}

// MARK: - Price
struct Price: Codable {
    
    var amount: Double
}

