//
//  NetworkManager.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 03.09.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private var numberOfFetchWithError = 0
    private let urlString = "https://phisix-api3.appspot.com/stocks.json"
    
    private init () {}
    
    func  fetchData(complitionHandeler: @escaping(MarketData)->Void)  {
        
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error)
                if self.numberOfFetchWithError < 5 {
                    self.numberOfFetchWithError += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchData() { (data) in
                            complitionHandeler(data)
                        }
                    }
                }
            }
            
            if let data = data {
                self.numberOfFetchWithError = 0
                if let currentMarketData = self.parseJSON(withData: data) {
                    
                    complitionHandeler(currentMarketData)
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> MarketData? {
        
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
