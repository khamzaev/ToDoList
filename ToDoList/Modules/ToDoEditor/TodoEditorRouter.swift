//
//  TodoEditorRouter.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

final class TodoEditorRouter: TodoEditorRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}
