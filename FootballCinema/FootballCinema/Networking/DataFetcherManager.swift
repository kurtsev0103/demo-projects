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

    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchMatches(completion: @escaping ([Match]?) -> Void) {
        let urlString = "https://www.scorebat.com/video-api/v1/"
        
        dataFetcher.fetchJSONData(urlString: urlString, response: completion)
    }
}
