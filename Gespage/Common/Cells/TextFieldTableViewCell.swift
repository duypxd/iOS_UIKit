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
    
    @IBOutlet weak var viewErrorMessage: UIView! // cha chứa errorMessageLabel và isHide = true
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
