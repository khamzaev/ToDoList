//
//  TodoSearchHeader.swift
//  ToDoList
//
//  Created by khamzaev on 03.03.2026.
//

import UIKit

final class TodoListSearchHeaderView: UIView, UISearchBarDelegate {

    var onTextChange: ((String) -> Void)?
    var onSearchButton: (() -> Void)?

    private let searchBar = UISearchBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self

        searchBar.searchTextField.backgroundColor = .secondarySystemBackground
        searchBar.searchTextField.layer.cornerRadius = 14
        searchBar.searchTextField.clipsToBounds = true

        searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true

        addSubview(searchBar)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = CGRect(x: 8, y: 8, width: bounds.width - 16, height: 44)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onTextChange?(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        onSearchButton?()
    }
}
