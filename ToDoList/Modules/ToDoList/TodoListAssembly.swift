//
//  TodoListAssembly.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

enum TodoListAssembly {
    
    static func build() -> UIViewController {
        
        let view = TodoListViewController()
        
        let stack = CoreDataStack(modelName: "ToDoList")
        let repository = TodosRepository(stack: stack)
        let router = TodoListRouter(repository: repository)
        let api = TodosAPI()
        let interactor = TodoListInteractor(repository: repository, api: api)
        
        let presenter = TodoListPresenter(view: view, interactor: interactor, router: router)
        
        interactor.output = presenter
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}
