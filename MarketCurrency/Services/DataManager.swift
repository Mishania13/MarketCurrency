//
//  DataManager.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 22.11.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import Foundation
//Make global enum for using in DataManger & CurrencyListModel
enum sortedBy: String { case name = "name", price = "price", percent = "percent" }

struct DataManager {
    
    static var shared = DataManager()
    
    var dataDictonary: [String:Bool] = [:]
    private let favoriteKey = "Favorite"
    private let userDefault = UserDefaults.standard
    
    private init(){
        loadDict()
    }
    
    mutating func saveDictonary() {
        userDefault.setValue(dataDictonary, forKey: favoriteKey)
    }
    
    private mutating func loadDict() {
        if let dictonary = userDefault.object(forKey: favoriteKey) as? [String:Bool] {
            dataDictonary = dictonary
        }
    }
    
    private mutating func saveValue(forName: String, value: Bool) {
        self.dataDictonary[forName] = value
    }
    
    //Load value from dict into cell
    mutating func loadValue(for name: String) -> Bool  {
        
        if dataDictonary[name] == nil {
            saveValue(forName: name, value: false)
            return false
        } else {
            return dataDictonary[name]!
        }
    }
    
    mutating func toggleValue(for name:String) {
            dataDictonary[name]?.toggle()
    }
    
    //MARK: - Sorting methods
    
    mutating func getLastSort()->String {
        for key in [sortedBy.name.rawValue, sortedBy.price.rawValue, sortedBy.percent.rawValue] {
            if dataDictonary[key] == true {
                return key
            } else if dataDictonary[key] == nil {
                saveValue(forName: key, value: false)
            }
         }
        return "no data"
    }
    
    mutating func sortStatus (for key: sortedBy) -> Bool {
        loadValue(for: key.rawValue)
    }
    
    mutating func toggleSortStatus(sortBy: sortedBy) {
        switch sortBy {
        case .name:
            toggleValue(for: sortedBy.name.rawValue)
            [sortedBy.percent.rawValue, sortedBy.price.rawValue].forEach{saveValue(forName: $0, value: false)}
        case .percent:
            toggleValue(for: sortedBy.percent.rawValue)
            [sortedBy.name.rawValue, sortedBy.price.rawValue].forEach{saveValue(forName: $0, value: false)}
        case .price:
            toggleValue(for: sortedBy.price.rawValue)
            [sortedBy.name.rawValue, sortedBy.percent.rawValue].forEach{saveValue(forName: $0, value: false)}
        }
        saveDictonary()
    }
}


