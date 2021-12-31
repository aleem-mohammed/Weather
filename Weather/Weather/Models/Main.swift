//
//  Main.swift
//  Weather
//
//  Created by Mohammed Aleem on 26/12/21.
//

import Foundation

struct Main: Codable {
    var temp: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        temp = try map.decodeIfPresent(Double.self, forKey: .temp)
        tempMin = try map.decodeIfPresent(Double.self, forKey: .tempMin)
        tempMax = try map.decodeIfPresent(Double.self, forKey: .tempMax)
        pressure = try map.decodeIfPresent(Int.self, forKey: .pressure)
    }
}
