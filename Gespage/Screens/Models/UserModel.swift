//
//  UserModel.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import Foundation

struct UserModel: Codable {
    var username: String? = nil
    var email: String? = nil
    var fullName: String? = nil
    var printCode: String? = nil
    var userCredit: Double? = 0
    var limited: Bool? = false
    var currency: String? = nil
    var department: String? = nil
    var reloadable: Bool? = false
    var supportEmail: String? = nil
    var paperFormats: [String]? = nil
}
