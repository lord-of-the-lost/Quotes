//
//  ViewController.swift
//  Quotes
//
//  Created by Николай Игнатов on 17.02.2025.
//

import UIKit

final class ViewController: UIViewController {
    let networkService: NetworkServiceProtocol = NetworkService()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "loading..."
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        fetchData()
    }
}

// MARK: - Private Methods
private extension ViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(label)
    }
    
    func fetchData() {
        networkService.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quotes):
                    self?.label.text = quotes.quote
                case .failure(let error):
                    self?.label.text = error.localizedDescription
                }
            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
