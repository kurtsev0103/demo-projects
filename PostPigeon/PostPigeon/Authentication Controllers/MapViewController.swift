//
//  MapViewController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 23/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAdress(_ adress: String?)
}

class MapViewController: UIViewController {

    private let mapView = MKMapView()
    private let cancelButton = UIButton()
    private let pinImageView = UIImageView(image: UIImage(named: kImageNamePin))
    private let saveButton = CustomButton(title: kButtonSave, buttonColor: Colors.lightBlue, type: .plain)
    private let currentAddressLabel = UILabel()
    private let locationManager = CLLocationManager()
    private let regionInMeters = 500.00
    private var isFirstTime = true
    
    var mapViewControllerDelegate: MapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupConstraints()
        setupButtons()
        setupImages()
        setupLabel()
        checkLocationServices()
        showUserLocation()
    }
    
    // MARK: - Private Method

    private func setupConstraints() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            saveButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20)
        ])
        
        currentAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(currentAddressLabel)
        
        NSLayoutConstraint.activate([
            currentAddressLabel.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            currentAddressLabel.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -100)
        ])
        
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(pinImageView)
        
        NSLayoutConstraint.activate([
            pinImageView.heightAnchor.constraint(equalToConstant: 50),
            pinImageView.widthAnchor.constraint(equalToConstant: 50),
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -15)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(equalToConstant: 50),
            cancelButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40),
            cancelButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20)
        ])
    }
    
    private func setupLabel() {
        currentAddressLabel.textAlignment = .center
        currentAddressLabel.numberOfLines = 0
        currentAddressLabel.font = Fonts.avenir26
        currentAddressLabel.textColor = .darkGray
        currentAddressLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        currentAddressLabel.layer.cornerRadius = 10
        currentAddressLabel.text = ""
    }
    
    private func setupButtons() {
        saveButton.isHidden = true
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        cancelButton.setImage(UIImage(named: kImageNameCancel), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    private func setupImages() {
        pinImageView.contentMode = .scaleToFill
    }
    
    // MARK: - Actions

    @objc func saveAction() {
        mapViewControllerDelegate?.getAdress(currentAddressLabel.text)
        dismiss(animated: true)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    // MARK: - Location Services Method
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: kAlertTitleCheckLocation, message: kAlertMessCheckLocation)
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: kAlertTitleError, message: kAlertMessRestrictedLocation)
            }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: kAlertTitleDeniedLocation, message: kAlertMessDeniedLocation)
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
                    self.saveButton.isHidden = false
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
