//
//  NetworkHelpers.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 18/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

class NetworkHelpers {
    
    // MARK: - Properties
    
    static let shared = NetworkHelpers()
    private init() {}
    
    // MARK: - Methods
    
    func parseCountries(_ data: Data) -> Countries? {
        do {
            let countries = try JSONDecoder().decode(Countries.self, from: data)
            return countries
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func parseText(_ data: Data) -> String? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                guard let array = json["ParsedResults"] as? [Any]           else { return nil }
                guard let dict  = array.first           as? [String: Any]   else { return nil }
                guard let text  = dict["ParsedText"]    as? String          else { return nil }
                
                return text
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func parseTranslatedText(_ data: Data) -> String? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                guard let text = json["translatedText"] as? String else { return nil }
                
                return text
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
