//
//  CountryViewController.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 02/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataFetcherManager = DataFetcherManager()
    var countries = [Country]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCountries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cvc = segue.destination as? CityViewController else { return }
        cvc.country = sender as? Country
    }
    
    private func fetchCountries() {
        dataFetcherManager.fetchCountries { (countriesModel) in
            guard let countriesModel = countriesModel else { return }
            self.countries = self.createCountriesFromModel(countriesModel: countriesModel)
            self.countries = self.countries.sorted { $0.name < $1.name }
            self.tableView.reloadData()
        }
    }
    
    private func createCountriesFromModel(countriesModel: CountriesModel) -> [Country] {
        var countries = [Country]()
        for country in countriesModel.countries {
            let country = Country(name: country.value, code: country.key)
            countries.append(country)
        }
        return countries
    }
    
    private func configureTableView() {
        tableView.register(CountryTableViewCell.nib(), forCellReuseIdentifier: CountryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as! CountryTableViewCell
        
        cell.configure(withCountry: countries[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: kSegueSearchCity, sender: countries[indexPath.row])
    }
}
