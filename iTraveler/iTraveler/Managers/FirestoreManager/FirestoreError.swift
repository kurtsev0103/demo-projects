//
//  FirestoreError.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 16/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

enum FirestoreError {
    case notFilled
    case photoNotExist
}

extension FirestoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString(kFillInAllTheInputFields, comment: "")
        case .photoNotExist:
            return NSLocalizedString(kPhotoNotExist, comment: "")
        }
    }
}
