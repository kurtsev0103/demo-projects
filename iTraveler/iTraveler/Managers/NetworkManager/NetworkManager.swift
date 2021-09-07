//
//  NetworkManager.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 17/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // MARK: - Properties
    
    static let shared = NetworkManager()
    private let sharedNetworkHelpers = NetworkHelpers.shared
    private init() {}
    
    // MARK: - Methods
    
    func requestApi(stringURL: String, method: HTTPMethod, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        guard NetworkReachabilityManager()?.isReachable == true else {
            completion(.failure(NetworkError.noNetwork))
            return
        }
                
        switch method {
            
        case .GET:
            
            AF.request(stringURL, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(response.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        case .POST:
            
            AF.request(stringURL, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(response.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        case .PUT:
            
            AF.request(stringURL, method: .put, parameters: parameters, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(response.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        case .PATCH:
            
            AF.request(stringURL, method: .patch, parameters: parameters, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(response.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        case .DELETE:
            
            AF.request(stringURL, method: .delete, parameters: parameters, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(response.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } //switch method
    } //requestApi
}

// MARK: - API request to get text from image
extension NetworkManager {
    
    func convertImageToText(image: UIImage?, completion: @escaping (Result<Data?, Error>) -> Void) {
        let imageData = image?.jpegData(compressionQuality: 0.6)
        let boundary = UUID().uuidString
        
        let parameters: Parameters = ["apikey": apiOCRKey,
                                      "isOverlayRequired": "True"]
        
        guard let url = URL(string: "https://api.ocr.space/Parse/Image") else { return }
        let data = createBodyWith(boundary: boundary, parameters: parameters, data: imageData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createBodyWith(boundary: String, parameters: Parameters, data: Data?) -> Data? {
        var body = Data()
        
        if data != nil {
            if let data1 = "--\(boundary)\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data1 = "Content-Disposition: form-data; name=\"\("file")\"; filename=\"image.jpeg\"\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data1 = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data = data {
                body.append(data)
            }
            if let data1 = "\r\n".data(using: .utf8) {
                body.append(data1)
            }
        }
        
        for key in parameters.keys {
            if let data1 = "--\(boundary)\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data1 = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let parameter = parameters[key], let data1 = "\(parameter)\r\n".data(using: .utf8) {
                body.append(data1)
            }
        }
        
        if let data1 = "--\(boundary)--\r\n".data(using: .utf8) {
            body.append(data1)
        }
        
        return body
    }
}

// MARK: - API request to get translated text
extension NetworkManager {
    func getTranslatedText(text: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        let headers = ["x-rapidapi-host": "language-translation.p.rapidapi.com",
                       "x-rapidapi-key": apiKey,
                       "content-type": "application/json",
                       "accept": "application/json"]
        
        let parameters = ["target": "ru",
                          "text": text,
                          "type": "plain"] as Parameters
        
        
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        guard let url = URL(string: "https://language-translation.p.rapidapi.com/translateLanguage/translate") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

