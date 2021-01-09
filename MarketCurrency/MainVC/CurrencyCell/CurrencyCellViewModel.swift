//
//  CurrencyCellViewModel.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 22.11.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import UIKit

//MARK:- Protocol
protocol CurrencyCellViewModelProtocol {
    
    var name: String {get}
    var amount: String {get}
    var volume: String {get}
    var percentChange: String {get}
    var priceAndPercentColor: UIColor {get}
    var isFavorite: Bool {get set}
    var percentChasngeDouble: Double {get}
    
    init (currencyInfo: Stock?)
    
    func changeFavoriteStatus()
    func getImageName() -> String
    
}
//MARK:- class
class CurrencyCustomCellViewModel: CurrencyCellViewModelProtocol {
    
    let currencyInfo: Stock?
    let name: String
    let amount: String
    let volume: String
    let percentChasngeDouble: Double
    
    var priceAndPercentColor: UIColor { get
    {
        if percentChasngeDouble < 0 {
            return UIColor.red
        } else if  percentChasngeDouble > 0 {
            return UIColor.systemGreen
        }
        return UIColor.systemGray
    }
    }
    
    var percentChange: String
    
    var isFavorite: Bool
    
    required init(currencyInfo: Stock?) {
        self.currencyInfo = currencyInfo
        self.name = currencyInfo?.name ?? "name"
        self.amount = String(currencyInfo?.price.amount ?? 0)
        self.percentChange = String(currencyInfo?.percentChange ?? 0) + "%"
        self.percentChasngeDouble = currencyInfo?.percentChange ?? 0
        self.volume = String(currencyInfo?.volume ?? 0)
        self.isFavorite = DataManager.shared.loadValue(for: name)
    }
    
    func changeFavoriteStatus () {
        DataManager.shared.toggleValue(for: name)
        isFavorite.toggle()
        DataManager.shared.saveDictonary()
    }
    
    func getImageName() -> String {
        return isFavorite ? "star.fill" : "star"
    }
}

