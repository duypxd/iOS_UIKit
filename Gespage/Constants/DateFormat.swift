//
//  DateFormat.swift
//  Gespage
//
//  Created by Duy Pham on 07/08/2023.
//

import Foundation

class DateFormat {
    static func formatYYYYMMDD(_ originalDateString: String, outputFormat: String) -> String? {
        
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
            if let date = inputFormatter.date(from: originalDateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = outputFormat
                return outputFormatter.string(from: date)
            } else {
                return nil
            }
        }
}
