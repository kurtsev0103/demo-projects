//
//  DataFetcherManager.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 03/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

class DataFetcherManager {
    
    var dataFetcher: DataFetcher

    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchCountries(completion: @escaping (CountriesModel?) -> Void) {
        let urlString = "https://countries-cities.p.rapidapi.com/location/country/list?format=json"
        
        let headers = ["x-rapidapi-host" : "countries-cities.p.rapidapi.com",
                       "x-rapidapi-key"  : kApiKey]
        
        dataFetcher.fetchJSONData(urlString: urlString, headers: headers, response: completion)
    }
    
    func fetchCities(countryCode: String, completion: @escaping (CityModel?) -> Void) {
        let urlString = "https://countries-cities.p.rapidapi.com/location/country/\(countryCode)/city/list"
        
        let headers = ["x-rapidapi-host" : "countries-cities.p.rapidapi.com",
                       "x-rapidapi-key"  : kApiKey]
        
        dataFetcher.fetchJSONData(urlString: urlString, headers: headers, response: completion)
    }
    
    func fetchCurrentWeather(cityName: String, completion: @escaping (WeatherModel?) -> Void) {
        let urlString = "https://community-open-weather-map.p.rapidapi.com/weather?q=\(cityName)&units=metric"
        
        let headers = ["x-rapidapi-host" : "community-open-weather-map.p.rapidapi.com",
                       "x-rapidapi-key"  : kApiKey]
        
        dataFetcher.fetchJSONData(urlString: urlString, headers: headers, response: completion)
    }
}
