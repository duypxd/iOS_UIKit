//
//  WelcomeViewController.swift
//  Gespage
//
//  Created by Duy Pham on 29/07/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var continueGuestButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        loginButton.layer.cornerRadius = 12.0
        loginButton.clipsToBounds = true
    }
    
}
