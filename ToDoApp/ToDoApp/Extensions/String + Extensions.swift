//
//  String + Extensions.swift
//  ToDoApp
//
//  Created by Oleksandr Kurtsev on 11/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

extension String {
    
    var percentEncoding: String {
        let allowedCharacters = CharacterSet(charactersIn: "~!@#$%^&*()-+=[]\\{},./?<>").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        return encodedString
    }
    
}
