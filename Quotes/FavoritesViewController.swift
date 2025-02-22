//
//  FavoritesViewController.swift
//  Quotes
//
//  Created by Николай Игнатов on 22.02.2025.
//

import UIKit

struct Quote {
    let text: String
    let author: String
    let date: String
}

final class QuotesViewController: UIViewController {
    private let quotes: [Quote] = [
        Quote(
            text: "Life is like riding a bicycle",
            author: "Albert Einstein",
            date: "01 Dec 2023-09.15am"
        ),
        Quote(
            text: "Stay hungry, stay foolish",
            author: "Steve Jobs",
            date: "02 Dec 2023-03.45pm"
        )
    ]
    
    private lazy var collectionView: UICollectionView = {
        let itemWidth = UIScreen.main.bounds.width - 50
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: 129)
        layout.minimumLineSpacing = 26
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: "QuoteCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension QuotesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        quotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "QuoteCell",
            for: indexPath
        ) as? QuoteCell else { return UICollectionViewCell() }
        
        let quote = quotes[indexPath.item]
        cell.configure(with: quote)
        
        return cell
    }
}

// MARK: - Private Methods
private extension QuotesViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

final class QuoteCell: UICollectionViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quoteLabel.text = nil
        authorLabel.text = nil
        dateLabel.text = nil
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with quote: Quote) {
        quoteLabel.text = quote.text
        authorLabel.text = "- \(quote.author)"
        dateLabel.text = quote.date
    }
}

// MARK: - Private Methods
private extension QuoteCell {
    func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(quoteLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(favoriteButton)
        contentView.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            quoteLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            quoteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            quoteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            favoriteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            favoriteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 20),
            favoriteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 2),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    @objc func favoriteButtonTapped() {
        
    }
}
