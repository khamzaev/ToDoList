//
//  TodoEditorContracts.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

protocol TodoEditorViewProtocol: AnyObject {
    func showTodo(title: String, description: String, createdAt: Date)
}

protocol TodoEditorPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String, description: String)
    func didTapBack()
}
protocol TodoEditorInteractorProtocol: AnyObject {
    func loadTodo()
    func save(title: String, description: String)
}
protocol TodoEditorInteractorOutput: AnyObject {
    func didLoad(todo: TodoItem)
    func didSave()
    func didFail(_ error: String)
    func didLoadInitial(title: String, description: String)
}
protocol TodoEditorRouterProtocol: AnyObject {
    func close()
}

