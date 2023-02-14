//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Влад on 09.02.2023.
//

import Foundation
import Combine
import CoreLocation

enum ViewState {
    case ready
    case loading
    case success
    case error(String)
}

class WeatherViewModel: NSObject, ObservableObject {
    
    let weatherAPI = WeatherAPI()
    let manager = CLLocationManager()
    
    @Published var viewState: ViewState = .ready
    @Published var weather: Weather?
    
    private var cancellable: AnyCancellable?
    private var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    private func requestLocation() {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            self.viewState = .error("Необходимо предоставить приложению доступ к геопозиции в настройках девайса")
        case .authorizedWhenInUse:
            manager.requestLocation()
        }
    }
    
    func getCurrentWeather() {
        if let location = location {
            self.viewState = .loading
            cancellable = weatherAPI.getCurrentWeather(lat: location.latitude, lon: location.longitude)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error) :
                        self.viewState = .error(error.localizedDescription)
                        print("error", error)
                    case .finished:
                        self.viewState = .success
                        print("finished")
                    }
                } receiveValue: { weather in
                    self.weather = weather
                }
        } else {
            self.viewState = .loading
            requestLocation()
        }
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        getCurrentWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        self.viewState = .error("Ошибка получения геопозиции:\(error.localizedDescription)")
    }
    
}
