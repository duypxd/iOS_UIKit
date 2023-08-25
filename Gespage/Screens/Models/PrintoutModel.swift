//
//  PrintoutModel.swift
//  Gespage
//
//  Created by Duy Pham on 07/08/2023.
//

import Foundation

struct PrintoutModelResponse: Decodable {
    let printoutId: Int
    let fileName: String
    let bwPages: Int
    let colorPages: Int
    let price: Double
    let date: String
    let status: String
    let description: String
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
