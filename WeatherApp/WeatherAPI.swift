//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Влад on 09.02.2023.
//

import Foundation
import Combine

enum APIError: LocalizedError {
    case incorrectURL(String)
}

class WeatherAPI {
    
    func getCurrentWeather(lat: Double, lon: Double) -> AnyPublisher<Weather, Error>{
        guard var url = URL(string: "http://api.weatherapi.com/v1/current.json") else {
            return Fail(error: APIError.incorrectURL("Incorrect URL"))
                .eraseToAnyPublisher()
        }
        url.append(queryItems: [ URLQueryItem(name: "q", value: "\(lat), \(lon)"),
                                 URLQueryItem(name: "lang", value: "ru"),
                                 URLQueryItem(name: "key", value: "df7eff6935614f4797073316231202") ])
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Weather.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
