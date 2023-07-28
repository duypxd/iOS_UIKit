//
//  OnboardViewController.swift
//  Gespage
//
//  Created by Duy Pham on 28/07/2023.
//

import UIKit

class OnboardViewController: UIViewController {

    @IBOutlet weak var onSkipOnboard: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSkipOnboard(_ sender: Any) {
        let storyboard = UIStoryboard(name: "WelcomeStoryboard", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            self.navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
}
