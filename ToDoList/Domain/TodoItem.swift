//
//  TodoItem.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

struct TodoItem: Equatable {
    let id: Int64
    let title: String
    let description: String
    let createdAt: Date
    let isCompleted: Bool
}
