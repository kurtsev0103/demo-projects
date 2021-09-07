//
//  CityViewController.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 03/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataFetcherManager = DataFetcherManager()
    var currentCity: City!
    var cities = [City]()
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCities()
    }
    
    private func fetchCities() {
        dataFetcherManager.fetchCities(countryCode: country.code) { (citiesModel) in
            guard let citiesModel = citiesModel else { return }
            self.cities = citiesModel.cities.sorted { $0.name < $1.name }
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        tableView.register(CityTableViewCell.nib(), forCellReuseIdentifier: CityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        
        cell.configure(withCity: cities[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentCity = cities[indexPath.row]
        performSegue(withIdentifier: kSegueMainVC, sender: nil)
    }
}
