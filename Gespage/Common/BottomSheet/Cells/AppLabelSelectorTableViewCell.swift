//
//  AppLabelSelectorTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 15/08/2023.
//

import UIKit

class AppLabelSelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var appSelectorView: UIView!
    @IBOutlet weak var appSelectorLabel: UILabel!
    @IBOutlet weak var appChecedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
