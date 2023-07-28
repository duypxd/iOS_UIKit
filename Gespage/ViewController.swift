//
//  ViewController.swift
//  Gespage
//
//  Created by Duy Pham on 28/07/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var onPressNextPage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func onPressNextPage(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "OnboardStoryboard", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "OnboardViewController") as? OnboardViewController {
            self.navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
}

