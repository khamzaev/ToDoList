//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

final class TodoListViewController: UIViewController, TodoListViewProtocol {
    
    private let tableView = UITableView()
    
    private let bottomBarView = TodoListBottomBarView()
    private let searchHeaderView = TodoListSearchHeaderView(frame: .zero)
    private var items: [TodoListViewModel] = []
    var presenter: TodoListPresenterProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        
        setupBottomBar()
        setupTableView()
        setupLongPress()
        setupSearchBar()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func setupSearchBar() {
        searchHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 56)
        
        searchHeaderView.onTextChange = { [weak self] text in
            self?.presenter.search(text: text)
        }
        
        tableView.tableHeaderView = searchHeaderView
    }
    
    
    private func setupBottomBar() {
        view.addSubview(bottomBarView)
        
        bottomBarView.onComposeTap = { [ weak self ] in
            self?.presenter.didTapAdd()
        }
        
        NSLayoutConstraint.activate([
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        view.addSubview(tableView)
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor)
        ])
    }
    
    private func setupLongPress() {
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        lp.minimumPressDuration = 0.45
        tableView.addGestureRecognizer(lp)
    }
    
    private func presentShare(for item: TodoListViewModel) {
        let text = "\(item.title)\n\n\(item.subtitle)\n\(item.dateText)"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }

        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }

        let item = items[indexPath.row]
        let overlay = TodoOverlayView(item: item)

        overlay.onEdit = { [weak self] in
            self?.presenter.didSelect(id: item.id)
        }

        overlay.onShare = { [weak self] in
            self?.presentShare(for: item)
        }

        overlay.onDelete = { [weak self] in
            self?.presenter.didDelete(id: item.id)
        }

        overlay.show(in: self.navigationController?.view ?? self.view)
    }
    
    
    func showTitle(_ text: String) {
        title = text
    }
    
    func showItems(_ items: [TodoListViewModel]) {
        self.items = items
        bottomBarView.setCount(items.count)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TodoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TodoCell
        
        let vm = items[indexPath.row]
        cell.configure(with: vm)
        
        cell.onToggle = { [weak self] in
            guard let self else { return }
            self.presenter.didTapToggleCompleted(id: vm.id)
        }
        
        
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            presenter.didDelete(id: item.id)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        presenter.didSelect(id: item.id)
    }
}

