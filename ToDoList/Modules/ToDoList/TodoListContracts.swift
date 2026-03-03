//
//  TodoListContracts.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

protocol TodoListViewProtocol: AnyObject {
    func showTitle(_ text: String)
    func showItems(_ items: [TodoListViewModel])
    func reloadRow(at indexPath: IndexPath)
}

protocol TodoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didTapAdd()
    func didDelete(id: Int64)
    func search(text: String)
    func didTapToggleCompleted(id: Int64)
    func didSelect(id: Int64)
}

protocol TodoListInteractorProtocol: AnyObject {
    func fetchTodos(query: String?)
    func deleteTodo(id: Int64)
    func toggleCompleted(id: Int64)
    func loadInitialIfNeeded()
}

protocol TodoListInteractorOutput: AnyObject {
    func didFetchTodos(_ items: [TodoItem])
    func didFail(_ error: Error)
}

protocol TodoListRouterProtocol: AnyObject {
    func openCreate()
    func openEditor(id: Int64)
    
}
