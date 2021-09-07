//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Oleksandr Kurtsev on 08/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var baseCurrencyTF: UITextField!
    @IBOutlet weak var desiredCurrencyTF: UITextField!
    @IBOutlet weak var baseCurrencyButton: DropDownButton!
    @IBOutlet weak var desiredCurrencyButton: DropDownButton!
    @IBOutlet weak var convertButton: UIButton!
    
    private let dataFetcherManager = DataFetcherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        convertButton.isHidden = true
        baseCurrencyButton.dropDownView.color = .systemYellow
        desiredCurrencyButton.dropDownView.color = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupBackground() {
        let backgroundImageView = UIImageView()
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        backgroundImageView.image = UIImage(named: kImageNameBackground)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    // MARK: - Validators
    private func isHaveDecimalPoint(number: String) -> Bool {
        if number.count == 0 { return true }
        let array = number.components(separatedBy: ".")
        return array.count > 1 ? true : false
    }
    
    private func isValidForMaxLength(number: String) -> Bool {
        return number.count <= 10 ? true : false
    }
    
    // MARK: - Actions
    
    @IBAction func convertAction(_ sender: UIButton) {
        guard let from = baseCurrencyButton.titleLabel?.text else { return }
        guard let to = desiredCurrencyButton.titleLabel?.text else { return }
        dataFetcherManager.fetchCurrencyConverter(from: from, to: to, amount: baseCurrencyTF.text!) { (currencyConverter) in
            self.desiredCurrencyTF.text = currencyConverter?.rate
        }
    }
    
    @IBAction func buttonsTapped(_ sender: UIButton) {
        convertButton.isHidden = false
        guard var number = baseCurrencyTF.text else { return }
        
        switch sender.tag {
        case 1...9:
            guard isValidForMaxLength(number: number) else { return }
            number += "\(sender.tag)"
        case 10:
            guard isValidForMaxLength(number: number) else { return }
            guard !isHaveDecimalPoint(number: number) else { return }
            number += "."
        case 0:
            guard isValidForMaxLength(number: number) else { return }
            number += "0"
        case 11:
            number = ""
            desiredCurrencyTF.text = ""
            convertButton.isHidden = true
        default: break
        }
        
        baseCurrencyTF.text = number
    }
}

