//
//  MainViewController.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 02/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var nameCityLabel: UILabel!
    
    var dataFetcherManager = DataFetcherManager()
    var firstLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstEntryCheck()
    }
    
    private func firstEntryCheck() {
        let userDefaults = UserDefaults.standard
        if let name = userDefaults.string(forKey: kSavedCityKey) {
            fetchCurrentWeather(cityName: name)
        } else {
            weatherIconImageView.image = nil
            nameCityLabel.text = "Please, select your desired city"
            temperatureLabel.text = ""
        }
    }
    
    private func fetchCurrentWeather(cityName: String) {
        dataFetcherManager.fetchCurrentWeather(cityName: cityName) { (weatherModel) in
            guard let weatherModel = weatherModel else { return }
            self.updateInterfaceWith(weatherModel: weatherModel)
        }
    }
    
    private func saveSelectedCityName(name: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(name, forKey: kSavedCityKey)
    }
    
    private func updateInterfaceWith(weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            let imageString = self.getSystemImageString(conditionCode: weatherModel.weather.first!.id)
            self.weatherIconImageView.image = UIImage(systemName: imageString)
            let tempStr = String(format: "%.0f", weatherModel.main.temp)
            self.temperatureLabel.text = tempStr + " °C"
            self.nameCityLabel.text = weatherModel.name
        }
    }
    
    private func getSystemImageString(conditionCode: Int) -> String {
        var systemIconNameString: String {
            switch conditionCode {
            case 200...232: return "cloud.bolt.rain.fill"
            case 300...321: return "cloud.drizzle.fill"
            case 500...531: return "cloud.rain.fill"
            case 600...622: return "cloud.snow.fill"
            case 701...781: return "smoke.fill"
            case 800: return "sun.max.fill"
            case 801...804: return "cloud.fill"
            default: return "nosign"
            }
        }
        return systemIconNameString
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? CityViewController else { return }
        fetchCurrentWeather(cityName: svc.currentCity.name)
        saveSelectedCityName(name: svc.currentCity.name)
    }
}
