//
//  TextFieldTableViewCell.swift
//  Gespage
//
//  Created by duy.pham on 24/08/2023.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var titleTextFieldLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var viewErrorMessage: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    func bindValidateError(_ message: String?) {
        let isHidden = message != nil && ((message?.isEmpty) == nil)
        viewErrorMessage.isHidden = isHidden
        errorMessageLabel.isHidden = isHidden
        errorMessageLabel.text = message ?? nil
    }
    
    func bindConfigureCell(
        _ title: String,
        _ placeholder: String,
        _ errMessage: String? = nil,
        _ isSecureTextEntry: Bool? = false,
        _ keyboardType: UIKeyboardType? = nil
    ) {
        titleTextFieldLabel.text = title
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType ?? .default
        textField.returnKeyType = .done
        textField.isSecureTextEntry = isSecureTextEntry ?? false
        errorMessageLabel.text = errMessage
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
