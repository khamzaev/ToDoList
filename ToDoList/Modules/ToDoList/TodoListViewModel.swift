//
//  TodoListViewModel.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

struct TodoListViewModel: Equatable {
    let id: Int64
    let title: String
    let subtitle: String
    let dateText: String
    let isCompleted: Bool
}
