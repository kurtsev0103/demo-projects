//
//  RemindPassViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 15/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class RemindPassViewController: UIViewController {

    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var sendEmailButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        prepareTextFields()
        prepareButtons()
    }
    
    // MARK: - Private Method
    
    private func prepareButtons() {
        sendEmailButton.setTitle(kButtonSendEmailTitle, for: .normal)
        cancelButton.setTitle(kButtonCancelTitle, for: .normal)
        cancelButton.backgroundColor = Colors.tropicRed
    }
    
    private func prepareTextFields() {
        emailTF.placeholder = kLoginTFPlaceholder
        emailTF.returnKeyType = .done
        emailTF.keyboardType = .emailAddress
        emailTF.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions

    @IBAction func cancelAction(_ sender: CustomButton) {
        sender.shake()
        dismiss(animated: true)
    }
    
    @IBAction func sendEmailAction(_ sender: CustomButton) {
        sender.shake()
        AuthManager.shared.resetPassword(email: emailTF.text) { (result) in
            switch result {
            case .success(_):
                self.showAlert(title: kAlertSuccess, message: kRecoveryPassword) {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                self.showAlert(title: kAlertError, message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension RemindPassViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
