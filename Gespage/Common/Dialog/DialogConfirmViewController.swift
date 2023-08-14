//
//  DialogConfirmViewController.swift
//  Gespage
//
//  Created by Duy Pham on 08/08/2023.
//

import UIKit

class DialogConfirmViewController: UIViewController {
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var titleText: String?
    var contentText: String?
    var confirmButtonLabel: String?
    var confirmButtonBackgroundColor: UIColor?
    var onConfirmAction: (() -> Void)?
    
    func showDialog(title: String, content: String, labelConfirm: String, backgroundColorConfirm: UIColor, onConfirm: (() -> Void)?) {
        titleText = title
        contentText = content
        confirmButtonLabel = labelConfirm
        confirmButtonBackgroundColor = backgroundColorConfirm
        self.onConfirmAction = onConfirm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // PassProps
        titleLabel.text = titleText
        contentLabel.text = contentText
        
        setUpUIButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }

    
    private func setUpUIButtons() {
        dialogView.layer.cornerRadius = 12
        
        confirmButton.layer.cornerRadius = 12
        confirmButton.backgroundColor = confirmButtonBackgroundColor
        if let titleLabel = confirmButton.titleLabel {
            titleLabel.textAlignment = .center
        }
        confirmButton.setTitle(confirmButtonLabel, for: .normal)
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc private func overlayTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - @IBAction
extension DialogConfirmViewController {
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        onConfirmAction?()
    }
}
