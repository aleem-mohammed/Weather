//
//  LocationManager.swift
//  Weather
//
//  Created by Mohammed Aleem on 25/12/21.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()
    @Published var status: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    let didUpdateLocation = PassthroughSubject<CLLocation, Never>()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        let status = self.manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("deined")
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            manager.requestLocation()
        @unknown default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("deined")
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            self.manager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        didUpdateLocation.send(lastLocation)
        self.lastLocation = lastLocation
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
