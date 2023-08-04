//
//  formater.swift
//  Gespage
//
//  Created by Duy Pham on 04/08/2023.
//

import Foundation

class Formater {
    static func formatAsUSD(amount: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        return formatter.string(from: NSNumber(value: amount / 100))
    }
}
