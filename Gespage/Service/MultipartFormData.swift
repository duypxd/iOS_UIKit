//
//  MultipartFormData.swift
//  Gespage
//
//  Created by duy.pham on 05/09/2023.
//

import Foundation

class MultipartFormData {
    private var body = Data()
    let boundary = "Boundary-\(UUID().uuidString)"
    
    init() {}
    
    func append(_ string: String, withName name: String) {
        let fieldString = "--\(boundary)\r\n" +
            "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n" +
            "\(string)\r\n"
        body.append(fieldString.data(using: .utf8) ?? Data())
    }
    
    func append(_ data: Data, withName name: String, fileName: String, mimeType: String) {
        let fieldString = "--\(boundary)\r\n" +
            "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n" +
            "Content-Type: \(mimeType)\r\n\r\n"
        body.append(fieldString.data(using: .utf8) ?? Data())
        body.append(data)
        body.append("\r\n".data(using: .utf8) ?? Data())
    }
    
    func httpBody() -> Data {
        let boundaryString = "--\(boundary)--\r\n"
        body.append(boundaryString.data(using: .utf8) ?? Data())
        return body
    }
}
