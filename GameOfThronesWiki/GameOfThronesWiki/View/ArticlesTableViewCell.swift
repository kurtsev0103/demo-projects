//
//  ArticlesTableViewCell.swift
//  GameOfThronesWiki
//
//  Created by Oleksandr Kurtsev on 21/08/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
    
    private var titleLabel = UILabel()
    private var abstractLabel = UILabel()
    private var thumbnailImageView = WebImageView()
    private var starButton: UIButton!
    private var isFavorite: Bool!
    var delegate: MainViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainWhite
        configureLabels()
        configureImageView()
        configureStarButton()
        setupConstraints()
    }
    
    func configure(withArticle article: Article) {
        titleLabel.text = article.title
        abstractLabel.text = article.abstract
        isFavorite = article.isFavorite
        selectionImageForStar()
        if let imageURL = article.thumbnail {
            thumbnailImageView.set(imageURL: imageURL)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureStarButton() {
        starButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        starButton.setImage(UIImage(named: kImageNameFavoriteStarGray), for: .normal)
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    
    @objc private func handleMarkAsFavorite() {
        delegate?.changeFavorites(cell: self)
        selectionImageForStar()
    }
    
    private func selectionImageForStar() {
        if isFavorite {
            starButton.setImage(UIImage(named: kImageNameFavoriteStarGold), for: .normal)
        } else {
            starButton.setImage(UIImage(named: kImageNameFavoriteStarGray), for: .normal)
        }
    }

    private func configureImageView() {
        thumbnailImageView.contentMode = .scaleToFill
        thumbnailImageView.layer.cornerRadius = 40
        thumbnailImageView.clipsToBounds = true
    }
    
    private func configureLabels() {
        abstractLabel.numberOfLines = 0
        abstractLabel.font = Fonts.avenir16
        abstractLabel.textColor = .lightGray
        titleLabel.font = Fonts.avenir20
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Constraints
extension ArticlesTableViewCell {
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(abstractLabel)
        addSubview(thumbnailImageView)
        addSubview(starButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        abstractLabel.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        starButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            starButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            starButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            starButton.heightAnchor.constraint(equalToConstant: 50),
            starButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: abstractLabel.topAnchor)
        ])
                
        NSLayoutConstraint.activate([
            abstractLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            abstractLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            abstractLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -16),
            abstractLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
