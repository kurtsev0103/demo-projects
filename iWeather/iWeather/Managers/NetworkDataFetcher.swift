//
//  NetworkDataFetcher.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 03/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func fetchJSONData<T: Decodable>(urlString: String, headers: HTTPHeaders?, response: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    var networking: Networking
    
    init(networking: Networking = NetworkManager()) {
        self.networking = networking
    }
    
    func fetchJSONData<T: Decodable>(urlString: String, headers: HTTPHeaders?, response: @escaping (T?) -> Void) {
        networking.request(urlString: urlString, headers: headers) { (data, error) in
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
}
