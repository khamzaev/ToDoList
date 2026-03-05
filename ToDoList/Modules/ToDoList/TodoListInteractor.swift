//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

final class TodoListInteractor: TodoListInteractorProtocol {
    
    weak var output: TodoListInteractorOutput?
    
    private let repository: TodosRepositoryProtocol
    private let api: TodosAPIProtocol
    private let defaults: UserDefaults
    private let didImportKey = "didImportRemoteTodos"
    
    
    init(repository: TodosRepositoryProtocol, api: TodosAPIProtocol, defaults: UserDefaults = .standard) {
        self.repository = repository
        self.api = api
        self.defaults = defaults
    }
    
    // MARK: - Helpers
    
    private func onMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread { block()}
        else { DispatchQueue.main.async {
            block()
        }}
    }
    
    private func reloadAll() {
        fetchTodos(query: nil)
    }
    
    private func fail(_ error: Error) {
        onMain {[weak self] in
            self?.output?.didFail(error)
        }
    }
    
    private func deliver(_ items: [TodoItem]) {
        onMain { [weak self] in
            self?.output?.didFetchTodos(items)
        }
    }
    
    
    func fetchTodos(query: String?) {
        repository.fetch(query: query) { [weak self] result in
            switch result {
            case .success(let items):
                self?.deliver(items)
            case .failure(let error):
                self?.fail(error)
            }
        }
    }
    
    
    func deleteTodo(id: Int64) {
        repository.delete(id: id) { [weak self] result in
            switch result {
            case .success:
                self?.reloadAll()
            case .failure(let error):
                self?.fail(error)
            }
        }
    }
    
    func toggleCompleted(id: Int64) {
        repository.fetch(query: nil) { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure(let error):
                self.fail(error)
            case .success(let items):
                guard let item = items.first(where: { $0.id == id }) else { return }

                let updated = TodoItem(
                    id: item.id,
                    title: item.title,
                    description: item.description,
                    createdAt: item.createdAt,
                    isCompleted: !item.isCompleted
                )

                self.repository.upsert(updated) { [weak self] saveResult in
                    guard let self else { return }
                    switch saveResult {
                    case .failure(let error):
                        self.fail(error)
                    case .success:
                        self.reloadAll()
                    }
                }
            }
        }
    }
    
    func loadInitialIfNeeded() {
        if defaults.bool(forKey: didImportKey) {
            reloadAll()
            return
        }

        api.fetchTodos { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure(let error):
                self.fail(error)
            case .success(let dtos):
                let now = Date()

                let items: [TodoItem] = dtos.map { dto in
                    TodoItem(
                        id: Int64(dto.id),
                        title: dto.todo,
                        description: "",
                        createdAt: now,
                        isCompleted: dto.completed
                    )
                }

                self.repository.upsert(items) { [weak self] saveResult in
                    guard let self else { return }
                    
                    switch saveResult {
                    case .failure(let error):
                        self.fail(error)
                    case .success:
                        self.defaults.set(true, forKey: self.didImportKey)
                        self.reloadAll()
                    }
                }
            }
        }
    }
}
