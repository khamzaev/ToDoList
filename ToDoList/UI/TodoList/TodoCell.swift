//
//  TodoCell.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import UIKit

final class TodoCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusButton = UIButton(type: .system)
    
    private let mainStack = UIStackView()
    
    var onToggle: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusButton.configuration = nil
        titleLabel.attributedText = nil
        descriptionLabel.textColor = .label
        onToggle = nil
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.textColor = .label
        
        
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .left
        
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.imageView?.contentMode = .scaleAspectFit
        statusButton.tintColor = .secondaryLabel
        statusButton.addTarget(self, action: #selector(didTapStatus), for: .touchUpInside)
        
        
        mainStack.axis = .vertical
        mainStack.spacing = 4
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(descriptionLabel)
        mainStack.addArrangedSubview(dateLabel)
        
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.alignment = .top
        rowStack.spacing = 12
        rowStack.translatesAutoresizingMaskIntoConstraints = false

        rowStack.addArrangedSubview(statusButton)
        rowStack.addArrangedSubview(mainStack)
        
        contentView.addSubview(rowStack)
        
        NSLayoutConstraint.activate([
            statusButton.widthAnchor.constraint(equalToConstant: 28),
            statusButton.heightAnchor.constraint(equalToConstant: 28),

            rowStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rowStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rowStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rowStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func didTapStatus() {
        onToggle?()
    }
    
    func configure(with item: TodoListViewModel) {
        titleLabel.text = item.title
        descriptionLabel.text = item.subtitle
        dateLabel.text = item.dateText

        let iconName = item.isCompleted ? "checkmark.circle.fill" : "circle"

        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: iconName)
        config.baseForegroundColor = item.isCompleted ? .systemYellow : .secondaryLabel
        config.contentInsets = .zero

        statusButton.configuration = config

        if item.isCompleted {
            let attrs: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.secondaryLabel
            ]
            titleLabel.attributedText = NSAttributedString(string: item.title, attributes: attrs)
            descriptionLabel.textColor = .secondaryLabel
        } else {
            titleLabel.attributedText = NSAttributedString(string: item.title)
            descriptionLabel.textColor = .label
        }
    }
}
