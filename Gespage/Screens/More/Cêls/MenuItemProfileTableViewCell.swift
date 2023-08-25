//
//  MenuItemProfileTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 12/08/2023.
//

import UIKit

class MenuItemProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    func bind(fullName: String, email: String){
        labelFullName.text = fullName
        labelEmail.text = email
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
