//
//  AvailableCurrencies.swift
//  CurrencyConverter
//
//  Created by Oleksandr Kurtsev on 08/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

struct AvailableCurrencies: Decodable {
    let currencies: [String: String]
}
