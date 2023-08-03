//
//  MockDataPrinters.swift
//  Gespage
//
//  Created by Duy Pham on 03/08/2023.
//

import Foundation

struct MockData {
    static var dataPrinters: [PrinterModel] = [
        PrinterModel(printerId: "XTX928361", name: "RICOH MP C301", status: "Available"),
        PrinterModel(printerId: "XTX123123", name: "RICOH MP C302", status: "Unavailable"),
        PrinterModel(printerId: "XTX223213", name: "RICOH MP C303", status: "Unavailable"),
        PrinterModel(printerId: "XTX028362", name: "RICOH MP C304", status: "Available"),
        PrinterModel(printerId: "XTXGAK273", name: "RICOH MP C305", status: "Unavailable"),
        PrinterModel(printerId: "XTX928KS2", name: "RICOH MP C306", status: "Unavailable"),
        PrinterModel(printerId: "XTXUSJ192", name: "RICOH MP C307", status: "Available"),
        PrinterModel(printerId: "XTX9AJD12", name: "RICOH MP C308", status: "Unavailable"),
        PrinterModel(printerId: "XTX123664", name: "RICOH MP C309", status: "Unavailable"),
        PrinterModel(printerId: "XTX123456", name: "RICOH MP C310", status: "Available"),
        PrinterModel(printerId: "XTX129384", name: "RICOH MP C311", status: "Unavailable"),
        PrinterModel(printerId: "XTX120919", name: "RICOH MP SP12", status: "Unavailable"),
        PrinterModel(printerId: "XTX000919", name: "RICOH MP PX12", status: "Unavailable"),
    ].sorted {(a, b) -> Bool in return a.status < b.status }
}
