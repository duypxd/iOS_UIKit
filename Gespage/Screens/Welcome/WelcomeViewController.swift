//
//  WelcomeViewController.swift
//  Gespage
//
//  Created by Duy Pham on 29/07/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    // @IBOutlet
    @IBOutlet weak var continueGuestButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

}

// MARK: - View Life Cycle
extension WelcomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginButton.layer.cornerRadius = 12.0
        loginButton.clipsToBounds = true
    }
}

// MARK: - @IBAction
extension WelcomeViewController: UIViewControllerTransitioningDelegate, LoginBottomSheetViewControllerDelegate {
    private func onReplaceMainPage() {
        navigationController?.setViewControllers([MainTabBarViewController()], animated: true)
        UserDefaults.standard.set(true, forKey: Constants.skipWelcomeKey)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LoginBottomSheetStoryboard", bundle: nil)
        if let loginBottomSheetVC = storyboard.instantiateViewController(withIdentifier: "LoginBottomSheetViewController") as? LoginBottomSheetViewController {
            loginBottomSheetVC.delegate = self
            loginBottomSheetVC.modalPresentationStyle = .custom
            loginBottomSheetVC.bottomSheetHeight = 430
            loginBottomSheetVC.transitioningDelegate = self
            present(loginBottomSheetVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func continueGuestButtonAction(_ sender: UIButton) {
        onReplaceMainPage()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: (presented as? LoginBottomSheetViewController)?.bottomSheetHeight, isDialog: false)
    }
    
    func didLoginSuccessfully() {
        onReplaceMainPage()
    }
}
