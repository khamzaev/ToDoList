//
//  TodoEditorInteractor.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

final class TodoEditorInteractor: TodoEditorInteractorProtocol {
     
    weak var output: TodoEditorInteractorOutput?
    
    private let repository: TodosRepositoryProtocol
    private let mode: TodoEditorMode
    private var loadedTodo: TodoItem?
    
    init(repository: TodosRepositoryProtocol, mode: TodoEditorMode) {
        self.repository = repository
        self.mode = mode
    }
    
    func loadTodo() {
        switch mode {
        case .create:
            output?.didLoadInitial(title: "", description: "")
            
        case .edit(let id):
            repository.fetch(query: nil) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let items):
                    guard let item = items.first(where: { $0.id == id }) else {
                        self.output?.didFail("Task not found")
                        return
                    }
                    self.loadedTodo = item
                    self.output?.didLoad(todo: item)
                    
                case .failure(let error):
                    self.output?.didFail(error.localizedDescription)
                }
            }
        }
    }
    
    func save(title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            output?.didFail("Title is required")
            return
        }

        switch mode {
        case .create:
            let newItem = TodoItem(
                id: Int64(Date().timeIntervalSince1970),
                title: trimmedTitle,
                description: description,
                createdAt: Date(),
                isCompleted: false
            )

            repository.upsert(newItem) { [weak self] result in
                switch result {
                case .success:
                    self?.output?.didSave()
                case .failure(let error):
                    self?.output?.didFail(error.localizedDescription)
                }
            }

        case .edit(let id):
            let originalCreatedAt = loadedTodo?.createdAt ?? Date()

            let updated = TodoItem(
                id: id,
                title: trimmedTitle,
                description: description,
                createdAt: originalCreatedAt,
                isCompleted: loadedTodo?.isCompleted ?? false
            )

            repository.upsert(updated) { [weak self] result in
                switch result {
                case .success:
                    self?.output?.didSave()
                case .failure(let error):
                    self?.output?.didFail(error.localizedDescription)
                }
            }
        }
    }
}
