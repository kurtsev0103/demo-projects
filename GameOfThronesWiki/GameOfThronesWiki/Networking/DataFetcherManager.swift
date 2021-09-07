//
//  DataFetcherManager.swift
//  Networking
//
//  Created by Oleksandr Kurtsev on 01/01/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class DataFetcherManager {
    
    var dataFetcher: DataFetcher

    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchArticles(completion: @escaping (ArticlesModel?) -> Void) {
        let urlString = "https://gameofthrones.fandom.com/api/v1/Articles/Top?expand=1&category=Articles&limit=75"
        dataFetcher.fetchJSONData(urlString: urlString, headers: nil, response: completion)
    }
    
    func fetchWholeDescription(withArticleID id: Int, completion: @escaping (ArticlesModel?) -> Void) {
        let urlString = "https://gameofthrones.fandom.com/api/v1/Articles/AsSimpleJson?id=\(id)"
        dataFetcher.fetchJSONData(urlString: urlString, headers: nil, response: completion)
    }
}
