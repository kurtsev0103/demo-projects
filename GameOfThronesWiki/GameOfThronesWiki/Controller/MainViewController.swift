//
//  MainViewController.swift
//  GameOfThronesWiki
//
//  Created by Oleksandr Kurtsev on 21/08/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    private let dataFetcherManager = DataFetcherManager()
    private let segmentedController = UISegmentedControl(items: [kTitleAll, kTitleFavorite])
    private let identifier = String(describing: ArticlesTableViewCell.self)
    private let tableView = UITableView()
    private var articles = [Article]()
    private var filteredArticles = [Article]()
    private var isFiltering: Bool {
        return self.segmentedController.selectedSegmentIndex == 1
    }
    
    var context: NSManagedObjectContext!
    var selectedCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTableView()
        setupSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingFromCoreDataArticles()
    }
    
    func changeFavorites(cell: ArticlesTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if isFiltering {
            filteredArticles[indexPath.row].isFavorite = !filteredArticles[indexPath.row].isFavorite
            filteredArticles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        } else {
            articles[indexPath.row].isFavorite = !articles[indexPath.row].isFavorite
            tableView.reloadData()
        }
        saveArticlesToCoreData()
    }
    
    // MARK: - Private Methods
    private func setupSegmentedControl() {
        segmentedController.selectedSegmentIndex = 0
        segmentedController.addTarget(self, action: #selector(handleSegmentSelected(_:)), for: .valueChanged)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentedController)
        guard #available(iOS 13, *) else {
            segmentedController.tintColor = .black
            return
        }
    }
    
    private func setupTableView() {
        tableView.register(ArticlesTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.backgroundColor = Colors.mainWhite
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        tableView.addGestureRecognizer(gesture)
    }
    
    private func checkFilteredArticles() {
        if isFiltering {
            filteredArticles = articles.filter({ (article) -> Bool in
                article.isFavorite
            })
        }
    }
    
    @objc private func handleSegmentSelected(_ sender: UISegmentedControl) {
        selectedCellIndexPath = nil
        checkFilteredArticles()
        tableView.reloadData()
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let indexPath = tableView.indexPathForRow(at: gesture.location(in: tableView)) else { return }
            
            if indexPath == selectedCellIndexPath {
                selectedCellIndexPath = nil
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                selectedCellIndexPath = indexPath
                fetchWholeDescription(indexPath: indexPath)
            }
        }
    }
    
    // MARK: - Fetch Request
    private func fetchArticles() {
        dataFetcherManager.fetchArticles { [weak self] (articles) in
            guard let articles = articles, let items = articles.items, let basepath = articles.basepath  else { return }
            self?.createArticlesInCoreData(articles: items, baseURL: basepath)
        }
    }
    
    private func fetchWholeDescription(indexPath: IndexPath) {
        let article = isFiltering ? filteredArticles[indexPath.row] : articles[indexPath.row]
        
        dataFetcherManager.fetchWholeDescription(withArticleID: Int(article.id)) { [weak self] (articlesModel) in
            guard let articles = articlesModel else { return }
            guard let sections = articles.sections else { return }
            guard let paragraphs = sections.first?.content else { return }
                        
            for (i, paragraph) in paragraphs.enumerated() {
                guard let text = paragraph.text else { return }
                                
                if i == 0 {
                    article.abstract = text
                } else {
                    article.abstract! += text
                }
            }  
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK - Core Data
    private func loadingFromCoreDataArticles() {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        let nameSort = NSSortDescriptor(key: "rating", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            articles = try context.fetch(fetchRequest)
            if articles.isEmpty {
                fetchArticles()
            }
            checkFilteredArticles()
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createArticlesInCoreData(articles: [Item], baseURL: String) {
        for (i, art) in articles.enumerated() {
            let article = Article(context: context)
            article.id = Int64(art.id)
            article.title = art.title
            article.abstract = art.abstract
            article.thumbnail = art.thumbnail
            article.isFavorite = false
            article.rating = Int16(i)
            article.stringURL = baseURL + art.url
            self.articles.append(article)
        }
        saveArticlesToCoreData()
        tableView.reloadData()
    }
    
    private func saveArticlesToCoreData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredArticles.count : articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ArticlesTableViewCell
        cell.delegate = self
        
        if isFiltering {
            cell.configure(withArticle: filteredArticles[indexPath.row])
        } else {
            cell.configure(withArticle: articles[indexPath.row])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath == indexPath {
            return UITableView.automaticDimension
        } else {
            return 96.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.article = isFiltering ? filteredArticles[indexPath.row] : articles[indexPath.row]
        vc.context = context
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Setup Constraints

extension MainViewController {
    private func setupConstraints() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
