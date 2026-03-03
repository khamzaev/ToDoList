//
//  TodoOverlayView.swift
//  ToDoList
//
//  Created by khamzaev on 02.03.2026.
//

import UIKit

final class TodoOverlayView: UIView {
    
    private var overlayBlurView: UIVisualEffectView?
    private var overlayCardContainer: UIView?
    private var overlayMenuContainer: UIView?
    private var overlayItem: TodoListViewModel?

    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?

    init(item: TodoListViewModel) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        overlayItem = item
        showOverlay(for: item)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in parent: UIView) {
        parent.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }
    
    private func showOverlay(for item: TodoListViewModel) {
        hideOverlay(animated: false)

        overlayItem = item

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.alpha = 0

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOverlayBackground))
        blur.addGestureRecognizer(tap)
        blur.isUserInteractionEnabled = true

        addSubview(blur)
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: topAnchor),
            blur.leadingAnchor.constraint(equalTo: leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let card = buildOverlayCard(for: item)
        blur.contentView.addSubview(card)

        let menu = buildOverlayMenu()
        blur.contentView.addSubview(menu)

        NSLayoutConstraint.activate([
            menu.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor, constant: 56),
            menu.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor, constant: -56),
            menu.bottomAnchor.constraint(equalTo: blur.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -160),

            card.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: menu.topAnchor, constant: -16)
        ])

        overlayBlurView = blur
        overlayCardContainer = card
        overlayMenuContainer = menu

        card.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        menu.transform = CGAffineTransform(translationX: 0, y: 20)

        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
            blur.alpha = 0.99
            card.transform = .identity
            menu.transform = .identity
        }
    }

    @objc private func didTapOverlayBackground() {
        hideOverlay(animated: true)
    }

    private func hideOverlay(animated: Bool) {
        guard let blur = overlayBlurView else { return }

        let cleanup = {
            blur.removeFromSuperview()
            self.overlayBlurView = nil
            self.overlayCardContainer = nil
            self.overlayMenuContainer = nil
            self.overlayItem = nil
            self.removeFromSuperview()
        }

        if !animated {
            cleanup()
            return
        }

        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn]) {
            blur.alpha = 0
            self.overlayCardContainer?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.overlayMenuContainer?.transform = CGAffineTransform(translationX: 0, y: 20)
        } completion: { _ in
            cleanup()
        }
    }
    
    private func buildOverlayCard(for item: TodoListViewModel) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOpacity = 0.22
        shadow.layer.shadowRadius = 16
        shadow.layer.shadowOffset = CGSize(width: 0, height: 10)

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.layer.cornerRadius = 18
        blur.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail

        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descLabel.textColor = .label
        descLabel.text = item.subtitle
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byTruncatingTail

        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        dateLabel.text = item.dateText

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        descLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        container.addSubview(shadow)
        shadow.addSubview(blur)
        blur.contentView.addSubview(titleLabel)
        blur.contentView.addSubview(descLabel)
        blur.contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            shadow.topAnchor.constraint(equalTo: container.topAnchor),
            shadow.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            shadow.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            blur.topAnchor.constraint(equalTo: shadow.topAnchor),
            blur.leadingAnchor.constraint(equalTo: shadow.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: shadow.trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: shadow.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: blur.contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor, constant: -16),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: blur.contentView.bottomAnchor, constant: -14),

            
        ])

        return container
    }

    private func buildOverlayMenu() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.layer.cornerRadius = 18
        blur.clipsToBounds = true

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0

        let edit = makeMenuButton(title: "Редактировать", systemImage: "pencil", isDestructive: false, action: #selector(didTapOverlayEdit))
        let share = makeMenuButton(title: "Поделиться", systemImage: "square.and.arrow.up", isDestructive: false, action: #selector(didTapOverlayShare))
        let delete = makeMenuButton(title: "Удалить", systemImage: "trash", isDestructive: true, action: #selector(didTapOverlayDelete))

        stack.addArrangedSubview(edit)
        stack.addArrangedSubview(makeSeparator())
        stack.addArrangedSubview(share)
        stack.addArrangedSubview(makeSeparator())
        stack.addArrangedSubview(delete)

        container.addSubview(blur)
        blur.contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: container.topAnchor),
            blur.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            stack.topAnchor.constraint(equalTo: blur.contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: blur.contentView.bottomAnchor),

            container.heightAnchor.constraint(equalToConstant: 168)
        ])

        return container
    }

    private func makeMenuButton(title: String, systemImage: String, isDestructive: Bool, action: Selector) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: systemImage)
        config.imagePadding = 12
        config.imagePlacement = .trailing
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        config.baseForegroundColor = isDestructive ? .systemRed : .label

        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: action, for: .touchUpInside)
        button.contentHorizontalAlignment = .fill
        return button
    }

    private func makeSeparator() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant: 1)
        ])
        return v
    }

    @objc private func didTapOverlayEdit() {
        hideOverlay(animated: true)
        onEdit?()
    }

    @objc private func didTapOverlayShare() {
        hideOverlay(animated: true)
        onShare?()
    }

    @objc private func didTapOverlayDelete() {
        hideOverlay(animated: true)
        onDelete?()
    }
}
