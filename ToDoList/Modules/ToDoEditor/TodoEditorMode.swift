//
//  TodoEditorMode.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

enum TodoEditorMode: Equatable {
    case create
    case edit(id: Int64)
}
