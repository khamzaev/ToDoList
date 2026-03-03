//
//  TodoEditorContentView.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

final class TodoEditorContentView: UIView {

    private let titleTextView = UITextView()
    private let descriptionTextView = UITextView()
    private let createdAtLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String, description: String, createdAt: Date) {
        titleTextView.text = title
        descriptionTextView.text = description

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        createdAtLabel.text = formatter.string(from: createdAt)
    }

    func currentTitle() -> String { titleTextView.text ?? "" }
    func currentDescription() -> String { descriptionTextView.text ?? "" }

    // MARK: - UI

    private func setupUI() {
        backgroundColor = .systemBackground

        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.backgroundColor = .clear
        titleTextView.textColor = .label
        titleTextView.font = .systemFont(ofSize: 44, weight: .bold)
        titleTextView.isScrollEnabled = false
        titleTextView.textContainerInset = .zero
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.textContainer.maximumNumberOfLines = 0
        titleTextView.textContainer.lineBreakMode = .byWordWrapping

        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.font = .systemFont(ofSize: 18, weight: .regular)
        createdAtLabel.textColor = .secondaryLabel

        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = .label
        descriptionTextView.font = .systemFont(ofSize: 20, weight: .regular)
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.isScrollEnabled = false

        addSubview(titleTextView)
        addSubview(createdAtLabel)
        addSubview(descriptionTextView)

        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            createdAtLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            createdAtLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            createdAtLabel.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor, constant: 24),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),

            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }

}
