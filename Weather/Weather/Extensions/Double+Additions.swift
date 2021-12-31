//
//  Double+Additions.swift
//  Weather
//
//  Created by Mohammed Aleem on 26/12/21.
//

import Foundation

extension Double {
    var formatted: String {
        return "\(Int(self))" + "°"
    }
    
    func dt(value: Double) -> Double {
        fabs(self - value)
    }
}
