//
//  Country.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 18/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

// MARK: - Countries
typealias Countries = [Country]

// MARK: - CountryElement
struct Country: Codable {
    let name: String
    let topLevelDomain: [String]
    let alpha2Code: String
    let alpha3Code: String
    let callingCodes: [String]
    let capital: String
    let altSpellings: [String]
    let region: String
    let subregion: String
    let population: Int
    let latlng: [Double]
    let demonym: String
    let area, gini: Double?
    let timezones: [String]
    let borders: [String]
    let nativeName: String
    let numericCode: String?
    let currencies: [String]
    let languages: [String]
    let translations: Translations
    let relevance: String?
}

// MARK: - Translations
struct Translations: Codable {
    let de, es, fr, ja, it: String?
}
