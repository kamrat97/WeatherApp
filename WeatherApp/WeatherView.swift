//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Влад on 09.02.2023.
//

import SwiftUI
import CoreLocationUI
import CoreLocation

struct WeatherView: View {
    
    @ObservedObject var viewModel = WeatherViewModel()
    
    var body: some View {
        switch viewModel.viewState {
        case .ready:
            Button {
                    viewModel.getCurrentWeather()
                } label: {
                    HStack {
                        Image(systemName: "cloud.fill")
                        Text("Получить прогноз")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(20)
                }
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .error:
            Text("error")
        case .success:
            VStack {
                if let weather = viewModel.weather {
                    Text(weather.location.region)
                    Text("\(weather.current.tempC)")
                        .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
