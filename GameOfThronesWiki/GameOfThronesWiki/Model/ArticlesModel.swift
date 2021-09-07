//
//  ArticlesModel.swift
//  GameOfThronesWiki
//
//  Created by Oleksandr Kurtsev on 21/08/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

// MARK: - ArticlesModel
struct ArticlesModel: Codable {
    let items: [Item]?
    let sections: [Section]?
    let basepath: String?
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    let url: String
    let title: String
    let abstract: String
    let thumbnail: String
}

// MARK: - Section
struct Section: Codable {
    let content: [Content]
}

// MARK: - Content
struct Content: Codable {
    let text: String?
}
