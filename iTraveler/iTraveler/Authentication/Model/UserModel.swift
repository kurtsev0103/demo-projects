//
//  UserModel.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 15/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

struct UserModel {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var bornDate: String = ""
    var gender: String = ""
    var phone: String = ""
    var address: String = ""
    var avatarStringURL: String = ""
    var id: String = ""
    
    var representation: [String: Any] {
        var rep = ["id": id]
        rep["firstName"] = firstName
        rep["lastName"] = lastName
        rep["email"] = email
        rep["bornDate"] = bornDate
        rep["gender"] = gender
        rep["phone"] = phone
        rep["address"] = address
        rep["avatarStringURL"] = avatarStringURL
        return rep
    }
}
