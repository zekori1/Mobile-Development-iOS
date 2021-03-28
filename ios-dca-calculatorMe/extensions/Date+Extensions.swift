//
//  Date+Extensions.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 28.03.2021.
//

import Foundation

extension Date {
    
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
