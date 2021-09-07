//
//  DataFetcherManager.swift
//  Networking
//
//  Created by Oleksandr Kurtsev on 01/01/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

class DataFetcherManager {
    
    var dataFetcher: DataFetcher
    var networking = NetworkManager()
    
    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }

    func fetchCurrencyConverter(from: String, to: String, amount: String, completion: @escaping (CurrencyConverter?) -> Void) {
        let urlString = "https://currency-converter5.p.rapidapi.com/currency/convert?format=json&from=\(from)&to=\(to)&amount=\(amount)"
        
        let headers = ["x-rapidapi-host": "currency-converter5.p.rapidapi.com",
                       "x-rapidapi-key" : kApiKey]
        
        networking.request(urlString: urlString, headers: headers) { (result) in
            switch result {
            case .success(let data):
                let currencyConverter = self.parseJSON(data: data, code: to)
                completion(currencyConverter)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    private func parseJSON(data: Data, code: String) -> CurrencyConverter? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
            guard let amount = json["amount"] as? String else { return nil }
            guard let baseCode = json["base_currency_code"] as? String else { return nil }
            guard let rates = json["rates"] as? [String: Any] else { return nil }
            guard let desiredCode = rates[code] as? [String: Any] else { return nil }
            guard let rate = desiredCode["rate_for_amount"] as? String else { return nil }
            let cc = CurrencyConverter(baseCurrencyCode: baseCode, desiredCurrencyCode: code, amount: amount, rate: rate)
            return cc
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
