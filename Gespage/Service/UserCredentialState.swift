//
//  UserState.swift
//  Gespage
//
//  Created by duy.pham on 24/08/2023.
//

import Foundation
import RxCocoa
import RxSwift

class UserCredentialState {
    static let shared = UserCredentialState()
    
    private let userCredentialSubject = BehaviorRelay<UserCredentialModel?>(value: nil)
    
    var userCredential: Observable<UserCredentialModel?> {
        return userCredentialSubject.asObservable()
    }
    
    private init() {
        // Khởi tạo UserCredential từ local storage [UserDefaults] nếu có
        if let savedCredentialData = UserDefaults.standard.data(forKey: AppDefaultsKeys.userCredentialsKey),
           let savedCredential = try? JSONDecoder().decode(UserCredentialModel.self, from: savedCredentialData) {
            updateUserModelResponse(savedCredential)
        }
    }
    
    private func updateUserModelResponse(_ newUserCredential: UserCredentialModel? = nil) {
        userCredentialSubject.accept(newUserCredential)
    }
    
    func saveUserCredential(_ newUserCredential: UserCredentialModel) {
        if let encodedCredential = try? JSONEncoder().encode(newUserCredential) {
            UserDefaults.standard.set(encodedCredential, forKey: AppDefaultsKeys.userCredentialsKey)
            updateUserModelResponse(newUserCredential)
        }
    }
    
    func deleteUserCredential() {
        UserDefaults.standard.removeObject(forKey: AppDefaultsKeys.userCredentialsKey)
        updateUserModelResponse(nil)
    }
}
