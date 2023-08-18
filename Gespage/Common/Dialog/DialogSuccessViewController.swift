//
//  DialogSuccessViewController.swift
//  Gespage
//
//  Created by Duy Pham on 18/08/2023.
//

import UIKit

class DialogSuccessViewController: UIViewController {

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    var titleText: String?
    var messageText: String?
    var buttonText: String?
    var onConfirmed: (() -> Void)?
    
    func showDialog(title: String, message: String, labelButton: String, onConfirm: (() -> Void)?) {
        titleText = title
        messageText = message
        buttonText = labelButton
        self.onConfirmed = onConfirm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Title, Message Dialog
        titleLabel.text = titleText
        messageLabel.text = messageText
        // UI Dialogs
        dialogView.layer.cornerRadius = 12
        buttonConfirm.layer.cornerRadius = 12
        if let titleLabel = buttonConfirm.titleLabel {
            titleLabel.textAlignment = .center
        }
        buttonConfirm.setTitle(buttonText, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonConfirm.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }

    
    @objc private func overlayTapped() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonConfirmAction(_ sender: UIButton) {
        onConfirmed?()
    }
}
