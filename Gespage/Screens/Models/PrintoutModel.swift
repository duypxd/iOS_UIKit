//
//  PrintoutModel.swift
//  Gespage
//
//  Created by Duy Pham on 07/08/2023.
//

import Foundation

struct PrintoutModelResponse: Decodable {
    var printoutId: Int
    var fileName: String
    var bwPages: Int
    var colorPages: Int
    var price: Double
    var date: String
    var status: String
}

struct PrintoutModelRequest: Decodable {
    var copies: String
    var color: String
    var format: String
    var duplex: String
    var files: [String]
    var selectedPages: String?
    var landscape: String
}
