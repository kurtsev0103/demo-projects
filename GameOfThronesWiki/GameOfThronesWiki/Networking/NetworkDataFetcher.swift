//
//  NetworkDataFetcher.swift
//  Networking
//
//  Created by Oleksandr Kurtsev on 01/01/2020.
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
        guard let data = from else { return nil }
        let decoder = JSONDecoder()

        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

