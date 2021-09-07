//
//  CountryViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 18/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class CountryInfoViewController: UIViewController {
    
    var country: Country!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alphaCodeLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var timezonesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        prepareNavigationTitle()
        prepareLabels()
    }
    
    // MARK: - Private Method
    
    private func prepareLabels() {
        nameLabel.font = UIFont(name: Fonts.avenir, size: 30)
        alphaCodeLabel.font = UIFont(name: Fonts.avenir, size: 30)
        capitalLabel.font = UIFont(name: Fonts.avenir, size: 30)
        regionLabel.font = UIFont(name: Fonts.avenir, size: 30)
        populationLabel.font = UIFont(name: Fonts.avenir, size: 30)
        timezonesLabel.font = UIFont(name: Fonts.avenir, size: 30)
        
        nameLabel.text = country.name
        alphaCodeLabel.text = country.alpha2Code + " / " + country.alpha3Code
        capitalLabel.text = country.capital
        regionLabel.text = country.region
        populationLabel.text = String(country.population) + " people"
        
        var string = ""
        for zone in country.timezones {
            string += zone + " "
        }
        timezonesLabel.text = string
    }

    private func prepareNavigationTitle() {
        navigationController?.navigationBar.barTintColor = Colors.tropicYellow
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: Fonts.avenir, size: 30)!, .foregroundColor: Colors.tropicBlue]
        
        if country.name.count > 7 {
            navigationItem.title = country.demonym
        } else {
            navigationItem.title = country.name
        }
        
        let backButton = UIBarButtonItem(title: kButtonItemBack, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([.font: UIFont(name: Fonts.avenir, size: 20)!], for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
