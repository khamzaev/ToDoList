//
//  CDTodo+Mapping.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

extension CDTodo {
    func toDomain() -> TodoItem {
        TodoItem(
            id: id,
            title: title ?? "",
            description: todoDescription ?? "",
            createdAt: createdAt ?? Date(),
            isCompleted: isCompleted
        )
    }
    
    func apply(_ item: TodoItem) {
        id = item.id
        title = item.title
        todoDescription = item.description
        createdAt = item.createdAt
        isCompleted = item.isCompleted
    }
}
