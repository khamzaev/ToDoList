//
//  TodoListPresenter.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

final class TodoListPresenter: TodoListPresenterProtocol {
    
    
    private weak var view: TodoListViewProtocol?
    private let interactor: TodoListInteractorProtocol
    private let router: TodoListRouterProtocol
    
    private var items: [TodoListViewModel] = []
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yy"
        
        return f
    }()
    
    init(view: TodoListViewProtocol,
         interactor: TodoListInteractorProtocol,
         router: TodoListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showTitle("Задачи")
        interactor.loadInitialIfNeeded()
    }
    
    func viewWillAppear() {
        interactor.fetchTodos(query: nil )
    }
    
    func didTapAdd() {
        router.openCreate()
    }
    
    func didSelect(id: Int64) {
        router.openEditor(id: id)
    }
    
    func didDelete(id: Int64) {
        interactor.deleteTodo(id: id)
    }
    
    func search(text: String) {
        let q = text.trimmingCharacters(in: .whitespacesAndNewlines)
        interactor.fetchTodos(query: q.isEmpty ? nil : q)
    }
    
    
    func didTapToggleCompleted(id: Int64) {
        interactor.toggleCompleted(id: id)
    }
    
    deinit {
        
    }
    
}

extension TodoListPresenter: TodoListInteractorOutput {
    
    func didFetchTodos(_ items: [TodoItem]) {
        
        self.items = items.map {
            
            return TodoListViewModel(
                id: $0.id,
                title: $0.title,
                subtitle: $0.description,
                dateText: formatter.string(from: $0.createdAt),
                isCompleted: $0.isCompleted
            )
        }
        
        view?.showItems(self.items)
    }
    
    func didFail(_ error: any Error) {
        print("TodoList error:", error.localizedDescription)
    }
    
}
