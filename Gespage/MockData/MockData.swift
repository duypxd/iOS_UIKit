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
        PrinterModel(printerId: "XTX123123", name: "RICOH MP C302", status: "Available"),
        PrinterModel(printerId: "XTX223213", name: "RICOH MP C303", status: "Available"),
        PrinterModel(printerId: "XTX028362", name: "RICOH MP C304", status: "Available"),
        PrinterModel(printerId: "XTXGAK273", name: "RICOH MP C305", status: "Available"),
        PrinterModel(printerId: "XTX928KS2", name: "RICOH MP C306", status: "Available"),
        PrinterModel(printerId: "XTXUSJ192", name: "RICOH MP C307", status: "Available"),
        PrinterModel(printerId: "XTX9AJD12", name: "RICOH MP C308", status: "Unavailable"),
        PrinterModel(printerId: "XTX123664", name: "RICOH MP C309", status: "Unavailable"),
        PrinterModel(printerId: "XTX123456", name: "RICOH MP C310", status: "Available")
    ].sorted {(a, b) -> Bool in return a.status < b.status }
    
    static var dataPrintouts: [PrintoutModelResponse] = [
        PrintoutModelResponse(
            printoutId: 1,
            fileName: "Tai_lieu_mat_quoc_gia.pdf",
            bwPages: 12,
            colorPages: 17,
            price: 83,
            date: "2023-08-12T02:12:32.670+00:00",
            status: "completed",
            description: "Gespage Mobile is a secure mobile print solution that allows you to easily print from your smartphone or tablet"
        ),
        PrintoutModelResponse(
            printoutId: 2,
            fileName: "apple_docs.pdf",
            bwPages: 4,
            colorPages: 24,
            price: 4421,
            date: "2023-07-07T02:55:32.670+00:00",
            status: "printing",
            description: "Easily print to printers on your network without having to install them on your smartphone. This service is compatible with various documents such as pdf, office, images..."
        ),
        PrintoutModelResponse(
            printoutId: 3,
            fileName: "google_docs.pdf",
            bwPages: 6,
            colorPages: 62,
            price: 9828,
            date: "2023-04-01T02:15:32.670+00:00",
            status: "error",
            description: "Track the environmental impact of your documents and try to improve it"
        ),
        PrintoutModelResponse(
            printoutId: 4,
            fileName: "meries.pdf",
            bwPages: 12,
            colorPages: 8,
            price: 1292,
            date: "2023-08-07T02:35:32.670+00:00",
            status: "pending",
            description: "Before you can proceed, you must read and accept the Terms and Conditions."
        ),
        PrintoutModelResponse(
            printoutId: 5,
            fileName: "my_pdf.pdf",
            bwPages: 9,
            colorPages: 21,
            price: 7120,
            date: "2023-08-07T02:09:34.670+00:00",
            status: "completed",
            description: "1. Enter or Scan Gespage server address"
        ),
        PrintoutModelResponse(
            printoutId: 6,
            fileName: "Bi_mat_quoc_gia.pdf",
            bwPages: 8,
            colorPages: 22,
            price: 9180,
            date: "2023-11-11T04:09:12.670+00:00",
            status: "error",
            description: "Gespage Terms and Conditions have changed. Gespage Mobile is a secure mobile print solution that allows you to easily print from your smartphone or tablet. Easily print to printers on your network without having to install them on your smartphone. This service is compatible with various documents such as pdf, office, images..."
        ),
        PrintoutModelResponse(
            printoutId: 7,
            fileName: "Bi_mat_quan_doi.pdf",
            bwPages: 27,
            colorPages: 17,
            price: 1800,
            date: "2023-12-24T05:09:43.670+00:00",
            status: "completed",
            description: "1. Enter or Scan Gespage server address"
        ),
        PrintoutModelResponse(
            printoutId: 8,
            fileName: "MyImage.png",
            bwPages: 24,
            colorPages: 12,
            price: 2180,
            date: "2023-03-27T08:58:32.670+00:00",
            status: "pending",
            description: "To sign in and connect your device to Gespage Mobile service. "
        ),
    ]
}
