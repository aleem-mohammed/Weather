//
//  WeatherObject.swift
//  Weather
//
//  Created by Mohammed Aleem on 26/12/21.
//

import Foundation

struct WeatherObject: Codable {
    var id: Int?
    var name: String?
    var cord: Cordinate?
    var main: Main?
    var weather: [Weather]?
}
