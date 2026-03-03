//
//  TodosDTO.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

struct TodosResponseDTO: Decodable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoDTO: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
