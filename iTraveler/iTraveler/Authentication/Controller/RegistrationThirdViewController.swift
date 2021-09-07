//
//  RegistrationViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 15/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import Firebase

class RegistrationThirdViewController: UIViewController {

    @IBOutlet weak var backButton: CustomButton!
    @IBOutlet weak var registrationButton: CustomButton!
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var passwordTwoTF: CustomTextField!

    private var progressIndicator: ProgressIndicator?
    
    var userModel: UserModel!
    var userImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        prepareTextFields()
        prepareButtons()
        prepareProgressIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTF.text = ""
        passwordTF.text = ""
        passwordTwoTF.text = ""
    }
    
    // MARK: - Private Method
    
    private func prepareButtons() {
        registrationButton.setTitle(kButtonRegistrationTitle, for: .normal)
        backButton.setTitle(kButtonBackTitle, for: .normal)
        backButton.backgroundColor = Colors.tropicRed
    }
    
    private func prepareTextFields() {
        emailTF.placeholder = kLoginTFPlaceholder
        emailTF.returnKeyType = .next
        emailTF.keyboardType = .emailAddress
        emailTF.delegate = self
        
        passwordTF.placeholder = kPassTFPlaceholder
        passwordTF.returnKeyType = .next
        passwordTF.keyboardType = .default
        passwordTF.isSecureTextEntry = true
        passwordTF.delegate = self
        
        passwordTwoTF.placeholder = kPassTwoTFPlaceholder
        passwordTwoTF.returnKeyType = .done
        passwordTwoTF.keyboardType = .default
        passwordTwoTF.isSecureTextEntry = true
        passwordTwoTF.delegate = self
    }
    
    private func prepareProgressIndicator() {
        progressIndicator = ProgressIndicator(view: view, loadingViewColor: UIColor(white: 1, alpha: 0.4), indicatorColor: .black, text: kPleaseWait, textColor: .black)
        progressIndicator?.isHidden = true
        self.view.addSubview(progressIndicator!)
    }
    
    private func animationRegistration() {
        backButton.isHidden = true
        registrationButton.isHidden = true
        emailTF.isHidden = true
        passwordTF.isHidden = true
        passwordTwoTF.isHidden = true
        progressIndicator?.isHidden = false
        progressIndicator!.start()
    }
    
    private func saveAllUserData() {
        FirestoreManager.shared.saveProfile(user: userModel, userImage: userImage) { (result) in
            switch result {
            case .success(_):
                self.progressIndicator!.stop()
                self.showAlert(title: kAlertSuccess, message: kYouAreRegistered) {
                    self.goToMainViewController()
                }
            case .failure(let error):
                self.showAlert(title: kAlertError, message: error.localizedDescription)
            }
        }
    }
    
    private func saveUserImage(currentUser: User) {
        userModel.id = currentUser.uid
        userModel.email = currentUser.email!
        
        StorageManager.shared.upload(userPhoto: userImage, userId: userModel.id) { (result) in
            switch result {
            case .success(let url):
                self.userModel.avatarStringURL = url.absoluteString
                self.saveAllUserData()
            case .failure(let error):
                self.showAlert(title: kAlertError, message: error.localizedDescription)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func registrationAction(_ sender: CustomButton) {
        sender.shake()
        
        AuthManager.shared.register(email: emailTF.text, password: passwordTF.text, confirmPassword: passwordTwoTF.text) { (result) in
            switch result {
            case .success(let user):
                self.animationRegistration()
                self.saveUserImage(currentUser: user)
            case .failure(let error):
                self.showAlert(title: kAlertError, message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func backAction(_ sender: CustomButton) {
        sender.shake()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationThirdViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF: passwordTF.becomeFirstResponder()
        case passwordTF: passwordTwoTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}
