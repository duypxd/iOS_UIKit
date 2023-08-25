//
//  MenuItemTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 12/08/2023.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func bind(labelName: String, iconName: String){
        label.text = labelName
        firstIcon.image = UIImage(named: iconName)
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
