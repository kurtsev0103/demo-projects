//
//  Matches.swift
//  FootballCinema
//
//  Created by Oleksandr Kurtsev on 05/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

struct Match: Decodable, Hashable {
    let uuid = UUID()

    let title: String
    let embed: String
    let url: String
    let thumbnail: String
    let date: String
    let side1: Side
    let side2: Side
    let competition: Competition
    let videos: [Video]
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return title.lowercased().contains(lowercasedFilter)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

struct Side: Decodable, Hashable {
    let name: String
    let url: String
}

struct Competition: Decodable, Hashable {
    let name: String
    let id: Int
    let url: String
}

struct Video: Decodable, Hashable {
    let title: String
    let embed: String
}
