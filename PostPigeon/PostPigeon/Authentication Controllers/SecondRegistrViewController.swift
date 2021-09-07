//
//  SecondRegistrViewController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 23/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class SecondRegistrViewController: UIViewController {
    
    private let imageHome = UIImageView(image: UIImage(named: kImageNameHome))
    private let imageLocation = UIImageView(image: UIImage(named: kImageNameLocation))
    private let backButton = CustomButton(title: kButtonBack, buttonColor: Colors.niceRed, type: .withBorder)
    private let nextButton = CustomButton(title: kButtonNext, buttonColor: Colors.niceWhite, type: .withBorder)
    private var phoneNumberTF = FPNTextField()
    private let addressTF = CustomTextField(type: .address)
    private var listController = FPNCountryListViewController(style: .grouped)
    private var isPhoneValid = false
    private let thirdVC = ThirdRegistrViewController()
    
    var userModel: MUser!
    var userImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackground()
        setupConstraints()
        setupTextFileds()
        setupButtons()
        setupLocationImage()
        setupListController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [backButton, nextButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        addressTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressTF)
        
        NSLayoutConstraint.activate([
            addressTF.heightAnchor.constraint(equalToConstant: 50),
            addressTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            addressTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addressTF.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
        
        phoneNumberTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneNumberTF)
        
        NSLayoutConstraint.activate([
            phoneNumberTF.heightAnchor.constraint(equalToConstant: 50),
            phoneNumberTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            phoneNumberTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            phoneNumberTF.bottomAnchor.constraint(equalTo: addressTF.topAnchor, constant: -5)
        ])
        
        imageHome.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageHome)
        
        NSLayoutConstraint.activate([
            imageHome.heightAnchor.constraint(equalToConstant: 25),
            imageHome.widthAnchor.constraint(equalToConstant: 25),
            imageHome.leftAnchor.constraint(equalTo: addressTF.leftAnchor, constant: 15),
            imageHome.centerYAnchor.constraint(equalTo: addressTF.centerYAnchor)
        ])
        
        imageLocation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageLocation)
        
        NSLayoutConstraint.activate([
            imageLocation.heightAnchor.constraint(equalToConstant: 30),
            imageLocation.widthAnchor.constraint(equalToConstant: 30),
            imageLocation.rightAnchor.constraint(equalTo: addressTF.rightAnchor, constant: -10),
            imageLocation.centerYAnchor.constraint(equalTo: addressTF.centerYAnchor)
        ])
    }

    private func setupTextFileds() {
        phoneNumberTF.placeholder = kPlaceholderPhone
        phoneNumberTF.keyboardType = .numberPad
        phoneNumberTF.delegate = self

        phoneNumberTF.setFlag(key: .UA)
        phoneNumberTF.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        phoneNumberTF.textColor = Colors.niceDark
        phoneNumberTF.tintColor = Colors.niceDark
        phoneNumberTF.font = Fonts.avenir20
        phoneNumberTF.layer.cornerRadius = 25
        phoneNumberTF.clipsToBounds = true
        
        addressTF.delegate = self
    }
    
    private func setupLocationImage() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        imageLocation.isUserInteractionEnabled = true
        imageLocation.addGestureRecognizer(recognizer)
    }
    
    private func setupListController() {
        phoneNumberTF.displayMode = .list
        
        listController.setup(repository: phoneNumberTF.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberTF.setFlag(countryCode: country.code)
        }
    }
    
    private func setupButtons() {
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func nextAction() {
        guard Validators.isFilledTextFields(phoneNumberTF.text, addressTF.text) else {
            showAlert(title: kAlertTitleError, message: kAlertTitleNotFilled)
            return
        }
        
        guard isPhoneValid else {
            showAlert(title: kAlertTitleError, message: kAlertMessWrongPhoneNumber)
            return
        }
        
        userModel.phone = phoneNumberTF.text!
        userModel.address = addressTF.text!
        
        thirdVC.modalPresentationStyle = .fullScreen
        thirdVC.modalTransitionStyle = .flipHorizontal
        thirdVC.userModel = userModel
        thirdVC.userImage = userImage
        present(thirdVC, animated: true)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        let vc = MapViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.mapViewControllerDelegate = self
        present(vc, animated: true)
    }
    
    @objc func backAction() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SecondRegistrViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneNumberTF: addressTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Keyboard Notifications

extension SecondRegistrViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SecondRegistrViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SecondRegistrViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

// MARK: - FPNTextFieldDelegate

extension SecondRegistrViewController: FPNTextFieldDelegate {
    
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

extension SecondRegistrViewController: MapViewControllerDelegate {
    func getAdress(_ adress: String?) {
        addressTF.text = adress
    }
}
