//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Влад on 12.02.2023.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var viewState: ViewState = .ready
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        self.viewState = .loading
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        self.viewState = .success
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        self.viewState = .error("Ошибка получения геопозиции:\(error.localizedDescription)")
    }
    
}
