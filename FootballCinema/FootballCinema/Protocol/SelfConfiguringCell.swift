//
//  SelfConfiguringCell.swift
//  FootballCinema
//
//  Created by Oleksandr Kurtsev on 05/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
