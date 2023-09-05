//
//  PrintoutModel.swift
//  Gespage
//
//  Created by Duy Pham on 07/08/2023.
//

import Foundation

struct PrintoutModelResponse: Codable {
    var printoutId: Int
    var fileName: String
    var bwPages: Int?
    var colorPages: Int?
    var price: Double?
    var date: String
    var status: String?
}

struct PrintoutModelRequest: Codable {
    var copies: Int = 0
    var color: Bool = true
    var format: String
    var duplex: Bool  = true
    var files: [String]
    var selectedPages: String?
    var landscape: Bool  = true
}

struct PrintoutIdsModel: Encodable {
    var printouts: [Int]
}

class MockDataPrintout {
    static var dataLandscape = ["Portrait", "Landscape"]
    static var dataColors = ["Color", "Black and white"]
    static var dataTwoSide = ["Yes", "No"]
}
