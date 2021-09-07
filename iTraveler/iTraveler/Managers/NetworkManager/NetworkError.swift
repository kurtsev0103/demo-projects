//
//  NetworkError.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 18/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

enum NetworkError {
    case noNetwork
    case failed
    case cancelled
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noNetwork:
            return NSLocalizedString(kNoNetwork, comment: "")
        case .failed:
            return NSLocalizedString(kFailedNetwork, comment: "")
        case .cancelled:
            return NSLocalizedString(kCanceledNetwork, comment: "")
        }
    }
}
