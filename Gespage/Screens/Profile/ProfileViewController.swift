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
    var userModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameLabel.text = userModel?.fullName
        departmentLabel.text = userModel?.department
        emailLabel.text = userModel?.email
        currentCreditLabel.text = userModel?.limited == true ? "Limited": "Unlimited"
        printCodeLabel.text = userModel?.printCode

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
