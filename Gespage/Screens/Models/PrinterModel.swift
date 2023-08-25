//
//  PrinterModel.swift
//  Gespage
//
//  Created by Duy Pham on 02/08/2023.
//

import Foundation

struct PrinterModel: Decodable {
    let printerId: String
    let printerName: String
    let printerStatus: Int
    let printerLocations: String
}
