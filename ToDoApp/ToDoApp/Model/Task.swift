//
//  Task.swift
//  ToDoApp
//
//  Created by Oleksandr Kurtsev on 10/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import Foundation

struct Task {
    
    let title: String
    let description: String?
    let location: Location?
    let date: Date
    
    init(title: String, description: String? = nil, date: Date? = nil, location: Location? = nil) {
        self.title = title
        self.description = description
        self.location = location
        self.date = date ?? Date()
    }
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        guard lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.location == rhs.location else { return false }
        return true
    }
}
