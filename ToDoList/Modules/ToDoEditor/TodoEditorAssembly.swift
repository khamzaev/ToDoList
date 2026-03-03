//
//  TodoEditorAssembly.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

enum TodoEditorAssembly {
    static func build(
        repository: TodosRepositoryProtocol,
        mode: TodoEditorMode
    ) -> UIViewController {
        let view = TodoEditorViewController()
        let router = TodoEditorRouter()
        let interactor = TodoEditorInteractor(repository: repository, mode: mode)
        let presenter = TodoEditorPresenter(
            view: view,
            interactor: interactor,
            router: router,
            mode: mode
        )
        
        view.presenter = presenter
        router.viewController = view
        interactor.output = presenter
        
        return view
    }
}
