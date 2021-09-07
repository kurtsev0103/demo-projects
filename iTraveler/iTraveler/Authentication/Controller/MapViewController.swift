//
//  MapViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 17/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAdress(_ adress: String?)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    
    private let locationManager = CLLocationManager()
    private let regionInMeters = 500.00
    private var isFirstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        prepareButtons()
        prepareImagePin()
        prepareLabel()
        checkLocationServices()
        showUserLocation()
    }

    // MARK: - Private Method

    private func prepareButtons() {
        saveButton.setTitle(kButtonSaveTitle, for: .normal)
        saveButton.isHidden = true
        
        cancelButton.backgroundColor = .clear
        cancelButton.setImage(UIImage(named: kCancelImage), for: .normal)
    }
    
    private func prepareImagePin() {
        pinImageView.image = UIImage(named: kPinImage)
    }
    
    private func prepareLabel() {
        currentAddressLabel.textAlignment = .center
        currentAddressLabel.numberOfLines = 0
        currentAddressLabel.font = UIFont(name: Fonts.avenir, size: 24)
        currentAddressLabel.textColor = .darkGray
        currentAddressLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        currentAddressLabel.layer.cornerRadius = 10
        currentAddressLabel.text = ""
    }
    
    // MARK: - Location Services Method
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: kCheckLocationTitle, message: kCheckLocationMessage)
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: kAlertError, message: kRestrictedLocationMessage)
            }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: kDeniedLocationTitle, message: kDeniedLocationMessage)
            }
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func showUserLocation() {
        guard let location = locationManager.location?.coordinate else { return }

        if isFirstTime {
            isFirstTime = false
            
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func getCenterLocation(mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Actions

    @IBAction func saveAction(_ sender: CustomButton) {
        sender.shake()
        mapViewControllerDelegate?.getAdress(currentAddressLabel.text)
        dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(mapView: mapView)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.currentAddressLabel.text = streetName! + ", " + buildNumber!
                } else if streetName != nil {
                    self.currentAddressLabel.text = streetName!
                    self.saveButton.isHidden = false
                } else {
                    self.currentAddressLabel.text = ""
                    self.saveButton.isHidden = true
                }
                
            }
            
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showUserLocation()
        }
    }
}
