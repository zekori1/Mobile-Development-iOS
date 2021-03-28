//
//  String+Extensions.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 28.03.2021.
//

extension String {
    
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
}
