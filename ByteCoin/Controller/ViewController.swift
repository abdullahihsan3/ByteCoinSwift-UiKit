//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
 
 


    
    
}


extension ViewController: CoinManagerDelegate{
    func didUpdateBitcoinPrices(_ coinManager: CoinManager, prices: BitcoinModel) {
        DispatchQueue.main.async {
            print("Prices Are: \(prices.rate)")
            self.bitcoinLabel.text = String(format: "%.3f", prices.rate)
            self.currencyLabel.text = prices.assetIDQuote
        }
      
    }
    
    func didFailWithError(error: Error) {
        print("Error")
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
 
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.delegate = self
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }

}

