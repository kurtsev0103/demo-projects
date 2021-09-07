//
//  CityModel.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 03/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

struct CityModel: Codable {
    let cities: [City]
}

struct City: Codable {
    let name: String
}
