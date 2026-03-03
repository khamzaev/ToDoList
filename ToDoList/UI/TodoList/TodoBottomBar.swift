//
//  TodoBottomBar.swift
//  ToDoList
//
//  Created by khamzaev on 03.03.2026.
//

import UIKit

final class TodoListBottomBarView: UIView {

    var onComposeTap: (() -> Void)?

    private let tasksCountLabel = UILabel()
    private let composeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCount(_ count: Int) {
        tasksCountLabel.text = "\(count) задач"
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray4

        tasksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        tasksCountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        tasksCountLabel.textColor = .secondaryLabel
        tasksCountLabel.textAlignment = .center
        tasksCountLabel.text = "0 задач"

        composeButton.translatesAutoresizingMaskIntoConstraints = false
        composeButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        composeButton.tintColor = .systemYellow
        composeButton.addTarget(self, action: #selector(didTapCompose), for: .touchUpInside)

        addSubview(separator)
        addSubview(tasksCountLabel)
        addSubview(composeButton)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 80),

            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),

            tasksCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tasksCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            composeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            composeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            composeButton.widthAnchor.constraint(equalToConstant: 32),
            composeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    @objc private func didTapCompose() {
        onComposeTap?()
    }
}


