//
//  CurrencyListViewModel.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 22.11.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import Foundation

//MARK:- Protocol
protocol CurrencyListViewModelProtocol {
    
    var currentMarketData: MarketData? {get}
    var numberOfRows: Int{get}
    
    var reloadData: () -> Void {get}
    
    func fetchMarketData(clousure: @escaping()->Void)
    func cellViewModel(at indexPath: IndexPath) -> CurrencyCellViewModelProtocol?
    func sortedByName()
    func sortedByPercentChange()
    func sortedByPrice()
    func getLastRowNumber() -> (Int)
    func loadLastSort()
}

//MARK:- Class

class CurrencyListViewModel: CurrencyListViewModelProtocol {
    
    var currentMarketData: MarketData?
    var reloadData: () -> Void
    
    var numberOfRows: Int {
        get {
            return self.currentMarketData?.stock.count ?? 1
        }
    }
    
    func fetchMarketData(clousure: @escaping () -> Void) {
        NetworkManager.shared.fetchData { (currentmarketDataResponse) in
            
            DispatchQueue.main.sync {
                self.currentMarketData = currentmarketDataResponse
                clousure()
            }
        }
    }
    
    
    func cellViewModel(at indexPath: IndexPath) -> CurrencyCellViewModelProtocol? {
        CurrencyCustomCellViewModel(currencyInfo: self.currentMarketData?.stock[indexPath.row])
    }
    
    func sortedByName() {
        
        if DataManager.shared.sortStatus(for: .name) {
            self.currentMarketData!.stock.sort{$0.name>$1.name}
        } else {
            self.currentMarketData!.stock.sort{$0.name<$1.name}
        }
        
        DataManager.shared.toggleSortStatus(sortBy: .name)
        
        DispatchQueue.main.async {self.reloadData()}
    }
    
    func sortedByPercentChange() {
        
        if DataManager.shared.sortStatus(for: .percent) {
            self.currentMarketData!.stock.sort{$0.percentChange>$1.percentChange}
        } else {
            self.currentMarketData!.stock.sort{$0.percentChange<$1.percentChange}
        }
        
        DataManager.shared.toggleSortStatus(sortBy: .percent)

        DispatchQueue.main.async {self.reloadData()}

    }
    
    func sortedByPrice() {
        if DataManager.shared.sortStatus(for: .price) {
            self.currentMarketData!.stock.sort{$0.price.amount>$1.price.amount}
        } else {
            self.currentMarketData!.stock.sort{$0.price.amount<$1.price.amount}
        }
        
        DataManager.shared.toggleSortStatus(sortBy: .price)

        DispatchQueue.main.async {self.reloadData()}
    }
    
    func loadLastSort() {
        
        switch DataManager.shared.getLastSort() {
        
        case sortedBy.name.rawValue:
            DataManager.shared.toggleSortStatus(sortBy: .name)
            self.sortedByName()
        case sortedBy.price.rawValue:
            DataManager.shared.toggleSortStatus(sortBy: .price)
            self.sortedByPrice()
        case sortedBy.percent.rawValue:
            DataManager.shared.toggleSortStatus(sortBy: .percent)
            self.sortedByPercentChange()
        default:
            self.sortedByName()
        }
    }
    
    func getLastRowNumber() -> (Int) {
        (currentMarketData?.stock.count)! - 1
    }
    
    init(reloadData: @escaping () -> Void) {
        self.reloadData = reloadData
    }
}
