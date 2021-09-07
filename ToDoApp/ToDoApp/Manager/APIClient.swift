//
//  APIClient.swift
//  ToDoApp
//
//  Created by Oleksandr Kurtsev on 11/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case emptyData
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared

    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        let allowedCharacters = CharacterSet.urlQueryAllowed
        ///     urlFragmentAllowed  "#%<>[\]^`{|}
        ///     urlHostAllowed      "#%/<>?@\^`{|}
        ///     urlPasswordAllowed  "#%/:<>?@[\]^`{|}
        ///     urlPathAllowed      "#%;<>?[\]^`{|}
        ///     urlQueryAllowed     "#%<>[\]^`{|}
        ///     urlUserAllowed      "#%/:<>?@[\]^`

        guard
            let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
            let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
                fatalError()
        }

        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "http://todoapp.com/login?\(query)") else { fatalError() }

        urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }

            do {
                guard let data = data else {
                    completionHandler(nil, NetworkError.emptyData)
                    return
                }

                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String : String]
                let token = dictionary["token"]
                completionHandler(token, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
}

