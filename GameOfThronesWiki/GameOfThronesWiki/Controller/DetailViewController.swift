//
//  DetailViewController.swift
//  GameOfThronesWiki
//
//  Created by Oleksandr Kurtsev on 22/08/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class DetailViewController: UIViewController {

    private let dataFetcherManager = DataFetcherManager()
    private var thumbnailImageView = WebImageView()
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    private var starButton: UIButton!
    private var safariButton: UIButton!
    private var abstractLabel: UILabel!
    
    var context: NSManagedObjectContext!
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = Colors.mainWhite
        
        configureStarButtons()
        configureScrollView()
        configureImageView()
        setupConstraints()
        fetchWholeDescription()
    }
    
    // MARK: - Private Methods
    private func configureScrollView() {
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsHorizontalScrollIndicator = false
        abstractLabel = UILabel(frame: .zero)
        abstractLabel.numberOfLines = 0
    }
    
    private func configureStarButtons() {
        starButton = UIButton(frame: .zero)
        safariButton = UIButton(frame: .zero)
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        safariButton.addTarget(self, action: #selector(handleOpenSafari), for: .touchUpInside)
        safariButton.setImage(UIImage(named: kImageNameSafari), for: .normal)
        selectionImageForStar()
    }
    
    private func configureImageView() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 50
        thumbnailImageView.clipsToBounds = true
        if let imageURL = article.thumbnail {
            thumbnailImageView.set(imageURL: imageURL)
        }
    }
    
    private func selectionImageForStar() {
        if article.isFavorite {
            starButton.setImage(UIImage(named: kImageNameFavoriteStarGold), for: .normal)
        } else {
            starButton.setImage(UIImage(named: kImageNameFavoriteStarGray), for: .normal)
        }
    }
    
    @objc private func handleMarkAsFavorite() {
        article.isFavorite = !article.isFavorite
        selectionImageForStar()
        saveArticlesToCoreData()
    }
    
    @objc private func handleOpenSafari() {
        guard let stringURL = article.stringURL else { return }
        guard let url = URL(string: stringURL) else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true)
    }
    
    // MARK: - Fetch Request
    private func fetchWholeDescription() {        
        dataFetcherManager.fetchWholeDescription(withArticleID: Int(article.id)) { [weak self] (articlesModel) in
            guard let articles = articlesModel else { return }
            guard let sections = articles.sections else { return }
            guard let paragraphs = sections.first?.content else { return }
                        
            for (i, paragraph) in paragraphs.enumerated() {
                guard let text = paragraph.text else { return }
                                
                if i == 0 {
                    self?.article.abstract = text
                } else {
                    self?.article.abstract! += text
                }
            }
            DispatchQueue.main.async {
                self?.abstractLabel.text = self?.article.abstract
            }
        }
    }
    
    // MARK: - Core Data
    private func saveArticlesToCoreData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Setup Constraints
extension DetailViewController {
    private func setupConstraints() {
        view.addSubview(thumbnailImageView)
        view.addSubview(safariButton)
        view.addSubview(starButton)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(abstractLabel)

        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        safariButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        abstractLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            starButton.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            starButton.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -16),
            starButton.heightAnchor.constraint(equalToConstant: 50),
            starButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            safariButton.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            safariButton.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 24),
            starButton.heightAnchor.constraint(equalToConstant: 50),
            starButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            abstractLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            abstractLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            abstractLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            abstractLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
