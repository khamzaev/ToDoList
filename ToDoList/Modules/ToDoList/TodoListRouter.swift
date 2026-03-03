//
//  TodoListRouter.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

final class TodoListRouter: TodoListRouterProtocol {
    weak var viewController: UIViewController?
    private let repository: TodosRepositoryProtocol
    
    init(repository: TodosRepositoryProtocol) {
        self.repository = repository
    }
    
    func openCreate() {
        let editor = TodoEditorAssembly.build(
            repository: repository,
            mode: .create
        )
        
        viewController?.navigationController?.pushViewController(editor, animated: true)
        
    }
    
    func openEditor(id: Int64) {
        let editor = TodoEditorAssembly.build(
            repository: repository,
            mode: .edit(id: id)
        )
        viewController?.navigationController?.pushViewController(editor, animated: true)
    }
}
