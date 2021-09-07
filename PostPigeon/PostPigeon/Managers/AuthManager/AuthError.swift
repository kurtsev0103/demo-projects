//
//  AuthError.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 21/06/2020.
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
            return NSLocalizedString(kAlertTitleNotFilled, comment: "")
        case .invalidEmail:
            return NSLocalizedString(kAlertTitleInvalidEmail, comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString(kAlertTitlePassNotMatched, comment: "")
        case .serverError:
            return NSLocalizedString(kAlertTitleServerError, comment: "")
        case .unknownError:
            return NSLocalizedString(kAlertTitleUnknownError, comment: "")
        }
    }
}
