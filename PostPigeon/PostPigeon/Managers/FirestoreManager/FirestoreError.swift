//
//  FirestoreError.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 22/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

enum FirestoreError {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToMUser
}

extension FirestoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString(kAlertTitleNotFilled, comment: "")
        case .photoNotExist:
            return NSLocalizedString(kAlertTitlePhotoNotExist, comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString(kAlertTitleCannotGetUserInfo, comment: "")
        case .cannotUnwrapToMUser:
            return NSLocalizedString(kAlertTitleCannotUnwrapToMUser, comment: "")
        }
    }
}
