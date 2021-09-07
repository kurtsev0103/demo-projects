//
//  CountriesModel.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 03/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

struct CountriesModel: Codable {
    let countries: [String: String]
}

struct Country {
    let name: String
    let code: String
}
