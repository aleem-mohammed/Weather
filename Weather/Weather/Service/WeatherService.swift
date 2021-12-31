//
//  WeatherService.swift
//  Weather
//
//  Created by Mohammed Aleem on 26/12/21.
//

import Foundation
class WeatherService {
    private init() { }
    static let shared = WeatherService()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let citiesInCirle = "find?lat=LATITUDE&lon=LONGITUDE&cnt=15&appid=d81752015e1301e55f1c516fd8caa920&units=metric"
    
    func fetchWeather(latitue: Double, longitude: Double, completion: @escaping ((ServerResult<WeatherResponse>) -> Void)) {
        var api = citiesInCirle.replacingOccurrences(of: "LATITUDE", with: "\(latitue)")
        api = api.replacingOccurrences(of: "LONGITUDE", with: "\(longitude)")
        let urlString = baseURL + api
        RequestManager.shared.fetchData(urlString: urlString, completion: completion)
    }
}
