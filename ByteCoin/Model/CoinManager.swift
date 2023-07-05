//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate{
    func didUpdateBitcoinPrices(_ coinManager: CoinManager, prices: BitcoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "41FE2956-CD77-4BF9-8618-CDC159414C1B"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    func getCoinPrice(for currency:String){
        let url:String = "\(baseURL)/\(currency)?apikey=\(apiKey)";
        performRequest(with: url)
    }
    func performRequest(with urlString: String){
    
        let session = URLSession(configuration: .default)
        if let url = URL(string: urlString) {
            let task = session.dataTask(with: url, completionHandler:  {(data: Data? , response: URLResponse?, error: Error?) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let updatedPrices = parseJSON(safeData){
                        self.delegate?.didUpdateBitcoinPrices(self, prices:updatedPrices)
                    }
                    
                }
            })
            task.resume()
        } else {
            print("could not open url, it was nil")
        }
      
    }
    
    
    func parseJSON(_ coinData:Data) -> BitcoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(BitcoinModel.self, from: coinData)
            let assetIDBase = decodedData.assetIDBase
            let assetIDQuote =  decodedData.assetIDQuote
            let rate = decodedData.rate
            let time = decodedData.time
            let priceModel = BitcoinModel(time: time, assetIDBase: assetIDBase, assetIDQuote: assetIDQuote, rate: rate)
            return priceModel
        } catch{
            print("Error Is: \(error)")
            delegate?.didFailWithError(error: error)
            return nil
        }
       }
    
}
