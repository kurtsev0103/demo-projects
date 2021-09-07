//
//  AuthError.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 15/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordsNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString(kFillInAllTheInputFields, comment: "")
        case .invalidEmail:
            return NSLocalizedString(kEmailFormatIsNotValid, comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString(kPasswordsNotMatched, comment: "")
        case .serverError:
            return NSLocalizedString(kServerError, comment: "")
        case .unknownError:
            return NSLocalizedString(kUnknownError, comment: "")
        }
    }
}
