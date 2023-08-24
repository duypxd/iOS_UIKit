//
//  ProfileViewController.swift
//  Gespage
//
//  Created by duy.pham on 21/08/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var currentCreditLabel: UILabel!
    @IBOutlet weak var printCodeLabel: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    var userCredential: UserCredentialModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameLabel.text = userCredential?.fullName
        departmentLabel.text = userCredential?.department
        emailLabel.text = userCredential?.email
        currentCreditLabel.text = userCredential?.limited == true ? "Limited": "Unlimited"
        printCodeLabel.text = userCredential?.printCode

        StyleHelper.commonLayer(layer: viewContainer.layer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
