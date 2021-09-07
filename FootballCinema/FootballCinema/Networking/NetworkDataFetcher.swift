//
//  NetworkDataFetcher.swift
//  Networking
//
//  Created by Oleksandr Kurtsev on 01/01/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation
import SwiftSoup

protocol DataFetcher {
    func fetchJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    var networking: Networking
    
    init(networking: Networking = NetworkManager()) {
        self.networking = networking
    }
    
    func fetchJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void) {
        networking.request(urlString: urlString) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                response(nil)
            }

            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func parseHTML(htmlString: String?) -> String? {
        guard let htmlString = htmlString else { return nil }
        guard let doc = try? SwiftSoup.parse(htmlString) else { return nil }
        guard let element = try? doc.select("iframe").first() else { return nil }
        guard let link = try? element.attr("src") else { return nil }
        return link
    }
}
