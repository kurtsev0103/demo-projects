//
//  NetworkManager.swift
//  Networking
//
//  Created by Oleksandr Kurtsev on 01/01/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol Networking {
    func request(urlString: String, headers: HTTPHeaders?, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: Networking {
    
    func request(urlString: String, headers: HTTPHeaders?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
            }
        }
    }
}
