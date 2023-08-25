//
//  UserModel.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import Foundation

struct SignInModelRequest: Codable {
    let username: String
    let password: String
}

struct UserCredentialModel: Codable {
    var username: String
    var email: String
    var fullName: String
    var printCode: String
    var userCredit: Double
    var limited: Bool
    var currency: String
    var department: String
    var reloadable: Bool
    var supportEmail: String
    var paperFormats: [String]
    var accessToken: String? = nil
}
