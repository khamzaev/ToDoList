//
//  TodoEditorPresenter.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

final class TodoEditorPresenter: TodoEditorPresenterProtocol {
    private weak var view: TodoEditorViewProtocol?
    private let interactor: TodoEditorInteractorProtocol
    private let router: TodoEditorRouterProtocol
    private let mode: TodoEditorMode
    
    init(
        view: TodoEditorViewProtocol,
        interactor: TodoEditorInteractorProtocol,
        router: TodoEditorRouterProtocol,
        mode: TodoEditorMode
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mode = mode
        
    }
    
    func viewDidLoad() {
        interactor.loadTodo()
    }
    
    func didTapSave(title: String, description: String) {
        interactor.save(title: title, description: description)
    }
    
    deinit {
        
    }
}


extension TodoEditorPresenter: TodoEditorInteractorOutput {
    
    func didLoad(todo: TodoItem) {
        view?.showTodo(
            title: todo.title,
            description: todo.description,
            createdAt: todo.createdAt
        )
    }
    
    func didLoadInitial(title: String, description: String) {
        view?.showTodo(
            title: title,
            description: description,
            createdAt: Date()
        )
    }
    
    func didSave() {
        router.close()
    }
    
    func didTapBack() {
        router.close()
    }
    
    func didFail(_ error: String) {
        print(error)
    }
    
    
    
    
}
