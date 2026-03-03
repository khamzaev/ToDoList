//
//  TodoEditorViewController.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

final class TodoEditorViewController: UIViewController, TodoEditorViewProtocol {
    
    var presenter: TodoEditorPresenterProtocol!
    private let contentView = TodoEditorContentView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupContentView()
        setupNavigationBar()
        
        presenter.viewDidLoad()
    }
    
    
    
    @objc private func didTapSave() {
        presenter.didTapSave(
            title: contentView.currentTitle(),
            description: contentView.currentDescription()
        )
    }
    
    @objc private func didTapBack() {
        presenter.didTapBack()
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle(" Назад", for: .normal)
        backButton.tintColor = .systemYellow
        backButton.setTitleColor(.systemYellow, for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(didTapSave)
        )
    }
    
    
    func showTodo(title: String, description: String, createdAt: Date) {
        contentView.set(title: title, description: description, createdAt: createdAt)
    }
}
