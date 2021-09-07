//
//  RegistrationSecondViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 15/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class RegistrationSecondViewController: UIViewController {

    @IBOutlet weak var backButton: CustomButton!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var phoneNumberTF: FPNTextField!
    @IBOutlet weak var addressTF: CustomTextField!
    @IBOutlet weak var timeZoneLabel: UILabel!
    
    private var listController = FPNCountryListViewController(style: .grouped)
    private var isPhoneValid = false
    
    var userModel: UserModel!
    var userImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        prepareTextFields()
        prepareButtons()
        prepareViews()
        prepareListController()
    }
    
    // MARK: - Private Method
    
    private func prepareTextFields() {
        phoneNumberTF.keyboardType = .numberPad
        phoneNumberTF = phoneNumberTF.customizeTF() as? FPNTextField
        phoneNumberTF.setFlag(key: .UA)
        phoneNumberTF.placeholder = kPhonePlaceholder
        phoneNumberTF.delegate = self
        
        addressTF.placeholder = kAddressTFPlaceholder
        addressTF.returnKeyType = .done
        addressTF = addressTF.customizeTF(withIdentView: true) as? CustomTextField
        addressTF.delegate = self
    }
    
    private func prepareButtons() {
        nextButton.setTitle(kButtonNextTitle, for: .normal)
        backButton.setTitle(kButtonBackTitle, for: .normal)
        backButton.backgroundColor = Colors.tropicRed
        
        mapButton.backgroundColor = .clear
        mapButton.setImage(UIImage(named: kMapImage), for: .normal)
    }
    
    private func prepareViews() {
        timeZoneLabel.font = UIFont(name: Fonts.avenir, size: 20)
        timeZoneLabel.text = kTimeZoneLabel + " " + TimeZone.current.identifier
    }
    
    private func prepareListController() {
        phoneNumberTF.displayMode = .list
        
        listController.setup(repository: phoneNumberTF.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberTF.setFlag(countryCode: country.code)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: CustomButton) {
        sender.shake()
        
        guard Validators.isFilledTextFields(phoneNumberTF.text, addressTF.text) else {
            showAlert(title: kAlertError, message: kFillInAllTheInputFields)
            return
        }
        
        guard isPhoneValid else {
            showAlert(title: kAlertError, message: kWrongPhoneNumber)
            return
        }
        
        userModel.phone = phoneNumberTF.text!
        userModel.address = addressTF.text!
        
        let vc = self.storyboard?.instantiateViewController(identifier: "RegistrationThirdViewController") as! RegistrationThirdViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.userModel = userModel
        vc.userImage = userImage
        self.present(vc, animated: true)
    }
    
    @IBAction func mapAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.mapViewControllerDelegate = self
        self.present(vc, animated: true)
        
    }
    
    @IBAction func backAction(_ sender: CustomButton) {
        sender.shake()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationSecondViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneNumberTF: addressTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - FPNTextFieldDelegate

extension RegistrationSecondViewController: FPNTextFieldDelegate {
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        self.present(navigationViewController, animated: true)
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        phoneNumberTF.text = ""
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            isPhoneValid = true
            view.endEditing(true)
        } else {
            isPhoneValid = false
        }
    }
}

// MARK: - MapViewControllerDelegate

extension RegistrationSecondViewController: MapViewControllerDelegate {
    func getAdress(_ adress: String?) {
        addressTF.text = adress
    }
}
