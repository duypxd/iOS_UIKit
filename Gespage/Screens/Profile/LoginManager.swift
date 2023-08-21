//
//  LoginManager.swift
//  Gespage
//
//  Created by duy.pham on 21/08/2023.
//

import UIKit

class LoginManager {
    static func presentBottomSheet(from viewController: UIViewController, delegate: LoginBottomSheetViewControllerDelegate) {
        let storyboard = UIStoryboard(name: "LoginBottomSheetStoryboard", bundle: nil)
        
        if let loginBottomSheetVC = storyboard.instantiateViewController(withIdentifier: "LoginBottomSheetViewController") as? LoginBottomSheetViewController {
            loginBottomSheetVC.delegate = delegate
            loginBottomSheetVC.modalPresentationStyle = .custom
            loginBottomSheetVC.bottomSheetHeight = 430
            loginBottomSheetVC.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
            
            viewController.present(loginBottomSheetVC, animated: true, completion: nil)
        }
    }
}
