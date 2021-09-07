//
//  RegistrationSecondViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 15/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class RegistrationFirstViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var bornDateTF: CustomTextField!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var nextButton: CustomButton!
    
    private var selectedTF: UITextField?
    private let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        prepareTextFields()
        createDatePicker()
        prepareImageView()
        prepareButtons()
        prepareSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    // MARK: - Private Method
    
    private func prepareButtons() {
        nextButton.setTitle(kButtonNextTitle, for: .normal)
        cancelButton.setTitle(kButtonCancelTitle, for: .normal)
        cancelButton.backgroundColor = Colors.tropicRed
    }
    
    private func prepareTextFields() {
        firstNameTF.placeholder = kFirstNameTFPlaceholder
        firstNameTF.autocapitalizationType = .words
        firstNameTF.returnKeyType = .next
        firstNameTF.delegate = self
        
        lastNameTF.placeholder = kLastNameTFPlaceholder
        lastNameTF.autocapitalizationType = .words
        lastNameTF.returnKeyType = .done
        lastNameTF.delegate = self
        
        bornDateTF.placeholder = kBornDateTFPlaceholder
        bornDateTF.delegate = self
    }
    
    private func prepareSegmentedControl() {
        genderSegmentedControl.selectedSegmentTintColor = Colors.tropicOrange
        genderSegmentedControl.setTitle(kSegmentedControlNameFirst, forSegmentAt: 0)
        genderSegmentedControl.setTitle(kSegmentedControlNameSecond, forSegmentAt: 1)
        genderSegmentedControl.setTitle(kSegmentedControlNameThird, forSegmentAt: 2)
    }
    
    private func prepareImageView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        photoImageView.image = UIImage(named: kNamePhotoDefaultImage)
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(recognizer)
        
        photoImageView.layer.borderWidth = 2
        photoImageView.layer.borderColor = UIColor.darkGray.cgColor
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
    }

    private func createDatePicker() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))

        let toolbar = UIToolbar()
        toolbar.backgroundColor = .systemOrange
        toolbar.setItems([doneButton], animated: true)
        toolbar.sizeToFit()
        
        bornDateTF.inputAccessoryView = toolbar
        bornDateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = -16
        let maxDate = calendar.date(byAdding: components, to: Date())
        components.year = -60
        let minDate = calendar.date(byAdding: components, to: Date())
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        
        bornDateTF.inputView?.backgroundColor = Colors.tropicYellow
    }
        
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "dd.MM.yyyy"
        bornDateTF.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: kActionSheetCamera, style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        let photo = UIAlertAction(title: kActionSheetPhoto, style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: kActionSheetCancel, style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: CustomButton) {
        sender.shake()
        
        guard Validators.isFilledTextFields(firstNameTF.text, lastNameTF.text, bornDateTF.text) && Validators.isMissingSpaces(firstNameTF.text) &&
            Validators.isMissingSpaces(lastNameTF.text) else {
                showAlert(title: kAlertError, message: kFillInAllTheInputFields)
                return
        }
        
        guard photoImageView.image != #imageLiteral(resourceName: "imageDefault") else {
            showAlert(title: kAlertError, message: kPhotoNotExist)
            return
        }
        
        var userModel = UserModel()
        userModel.firstName = (firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        userModel.lastName = (lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        userModel.bornDate = bornDateTF.text!
        userModel.gender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)!
        
        print(userModel.firstName)

        let vc = self.storyboard?.instantiateViewController(identifier: "RegistrationSecondViewController") as! RegistrationSecondViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.userModel = userModel
        vc.userImage = photoImageView.image
        self.present(vc, animated: true)
    }
    
    @IBAction func cancelAction(_ sender: CustomButton) {
        sender.shake()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationFirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTF: lastNameTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == bornDateTF {
            selectedTF = textField
            return true
        } else {
            selectedTF = nil
            if self.view.frame.origin.y != 0 {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y += 50
                }
            }
        }
        return true
    }
}

// MARK: - Keyboard Notifications

extension RegistrationFirstViewController {
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationFirstViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationFirstViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard selectedTF == bornDateTF else { return }
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 50
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        guard selectedTF == bornDateTF else { return }
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 50
        }
    }
}

// MARK: - Image Tapped

extension RegistrationFirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true)
    }
}

