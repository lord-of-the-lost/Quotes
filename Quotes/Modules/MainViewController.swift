//
//  MainViewController.swift
//  Quotes
//
//  Created by Николай Игнатов on 17.02.2025.
//

import UIKit

struct Quote {
    let text: String
    let author: String
    let date: String
    var isSaved: Bool = false
}

final class MainViewController: UIViewController {
    let networkService: NetworkServiceProtocol = NetworkService()
    private let dispatchGroup = DispatchGroup()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Введите ваш запрос"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var logo: UIImageView = {
        let image = UIImage(resource: .logo)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.split.2x2.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var topQuoteView: QuoteView = {
        let quoteView = QuoteView()
        quoteView.alpha = 0
        quoteView.translatesAutoresizingMaskIntoConstraints = false
        return quoteView
    }()
    
    private lazy var bottomQuoteView: QuoteView = {
        let quoteView = QuoteView()
        quoteView.alpha = 0
        quoteView.translatesAutoresizingMaskIntoConstraints = false
        return quoteView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        fetchData()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(logo)
        view.addSubview(searchBar)
        view.addSubview(categoryButton)
        view.addSubview(topQuoteView)
        view.addSubview(bottomQuoteView)
        view.addSubview(activityIndicator)
    }
    
    func fetchData() {
        startLoadingAnimation()
        var topQuote: Quote?
        var bottomQuote: Quote?
        
        dispatchGroup.enter()
        networkService.fetchData { [weak self] result in
            defer { self?.dispatchGroup.leave() }
            switch result {
            case .success(let model):
                topQuote = self?.convertToQuote(model)
            case .failure(let error):
                print("Top quote error: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.enter()
        networkService.fetchData { [weak self] result in
            defer { self?.dispatchGroup.leave() }
            switch result {
            case .success(let model):
                bottomQuote = self?.convertToQuote(model)
            case .failure(let error):
                print("Bottom quote error: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.stopLoadingAnimation()
            
            if let top = topQuote {
                self?.updateQuoteView(self?.topQuoteView, with: top)
            }
            
            if let bottom = bottomQuote {
                self?.updateQuoteView(self?.bottomQuoteView, with: bottom)
            }
        }
    }
    
    private func convertToQuote(_ model: QuoteModel) -> Quote {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return Quote(
            text: model.quote,
            author: model.author,
            date: dateFormatter.string(from: Date()),
            isSaved: false
        )
    }
    
    private func updateQuoteView(_ view: QuoteView?, with quote: Quote) {
        guard let view = view else { return }
        view.configure(with: quote)
        animateQuoteAppearance(view: view)
    }
    
    func animateQuoteAppearance(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            view.alpha = 1
            view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                view.transform = .identity
            }
        }
    }
    
    func startLoadingAnimation() {
        activityIndicator.startAnimating()
    }
    
    func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchBar.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            topQuoteView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            topQuoteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 42),
            topQuoteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -42),
            topQuoteView.heightAnchor.constraint(equalToConstant: 250),
            
            bottomQuoteView.topAnchor.constraint(equalTo: topQuoteView.bottomAnchor, constant: 15),
            bottomQuoteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 42),
            bottomQuoteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -42),
            bottomQuoteView.heightAnchor.constraint(equalToConstant: 250),
            
            categoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            categoryButton.widthAnchor.constraint(equalToConstant: 40),
            categoryButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func categoryButtonTapped() {
        let controller = CategoriesViewController()
        present(controller, animated: true)
    }
}
