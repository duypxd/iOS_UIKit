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
extension WelcomeViewController {
    private func onReplaceMainPage() {
        let storyboard = UIStoryboard(name: "MainGespageStoryboard", bundle: nil)
        if let maingespageViewController = storyboard.instantiateViewController(withIdentifier: "MainGespageViewController") as? MainGespageViewController {
            navigationController?.setViewControllers([maingespageViewController], animated: true)
        }
        UserDefaults.standard.set(true, forKey: Constants.skipWelcomeKey)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        onReplaceMainPage()
    }
    
    @IBAction func continueGuestButtonAction(_ sender: UIButton) {
        onReplaceMainPage()
    }
}
