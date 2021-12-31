//
//  WeatherResponse.swift
//  Weather
//
//  Created by Mohammed Aleem on 26/12/21.
//

import Foundation

struct WeatherResponse: Codable {
    var message: String?
    var count: Int?
    var list: [WeatherObject]?
}
