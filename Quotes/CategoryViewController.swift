//
//  CategoryViewController.swift
//  Quotes
//
//  Created by Николай Игнатов on 20.02.2025.
//

import UIKit

final class CategoriesViewController: UIViewController {
    private let categories = ["Family", "Friends", "Work", "Health", "Love", "Other"]
    private var selectedCategories: Set<String> = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "What makes you feel that way?"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "you can select more than one"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var bottomHintLabel: UILabel = {
        let label = UILabel()
        label.text = "you can change it later"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategories()
        setupConstraints()
    }
}

// MARK: - Private Methods
private extension CategoriesViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(questionLabel)
        view.addSubview(hintLabel)
        view.addSubview(stackView)
        view.addSubview(bottomHintLabel)
        view.addSubview(doneButton)
    }
    
    func setupCategories() {
        categories.forEach { category in
            let categoryView = CategoryView()
            categoryView.configure(title: category)
            categoryView.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(categoryTapped)))
            stackView.addArrangedSubview(categoryView)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            hintLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            
            bottomHintLabel.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
            bottomHintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func categoryTapped(_ gesture: UITapGestureRecognizer) {
        guard let categoryView = gesture.view as? CategoryView else { return }
        let category = categoryView.title
        
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        
        categoryView.setSelected(selectedCategories.contains(category))
    }
    
    @objc func doneButtonTapped() {
        print("Selected categories: \(selectedCategories)")
        dismiss(animated: true)
    }
}
