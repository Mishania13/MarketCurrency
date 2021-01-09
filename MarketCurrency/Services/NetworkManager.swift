//
//  NetworkManager.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 03.09.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    let urlString = "https://phisix-api3.appspot.com/stocks.json"
    
    
    private init () {}
    
    func fetchData(complitionHandeler: @escaping(MarketData)->Void)  {
        
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                print(error)
            }
            
            if let data = data {

                if let currentMarketData = self.parseJSON(withData: data) {
                   
                    complitionHandeler(currentMarketData)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> MarketData? {
        
        let decoder = JSONDecoder()
        do {
        let currentMarketData = try decoder.decode(MarketData.self, from: data)
        return currentMarketData
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
