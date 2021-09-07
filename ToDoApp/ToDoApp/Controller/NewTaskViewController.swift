//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Oleksandr Kurtsev on 11/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {
    
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBAction func save() {
        guard
            let dateString = dateTextField.text,
            let locationString = locationTextField.text,
            let addressString = addressTextField.text,
            let titleString = titleTextField.text else { return }
        
        let descriptionString = descriptionTextField.text
        let date = dateFormatter.date(from: dateString)
        
        geocoder.geocodeAddressString(addressString) { [unowned self] (placemarks, error) in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString, coordinate: coordinate)
            let task = Task(title: titleString, description: descriptionString, date: date, location: location)
            self.taskManager.add(task: task)
        }
    }
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
}
