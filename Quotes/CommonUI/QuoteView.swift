//
//  QuoteView.swift
//  Quotes
//
//  Created by Николай Игнатов on 23.02.2025.
//

import UIKit

protocol QuoteViewDelegate: AnyObject {
    func favoriteButtonTapped()
    func refreshButtonTapped()
}

final class QuoteView: UIView {
    weak var delegate: QuoteViewDelegate?
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func configure(with quote: Quote) {
        quoteLabel.text = quote.text
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension QuoteView {
    func setupView() {
        backgroundColor = .yellow
        layer.cornerRadius = 25
        addSubview(quoteLabel)
        addSubview(favoriteButton)
        addSubview(refreshButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            quoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            quoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            quoteLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.7),
            
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            favoriteButton.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 20),
            
            refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            refreshButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            refreshButton.widthAnchor.constraint(equalToConstant: 20),
            refreshButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    @objc func favoriteButtonTapped() {
        delegate?.favoriteButtonTapped()
    }
    
    @objc func refreshButtonTapped() {
        delegate?.refreshButtonTapped()
    }
}
