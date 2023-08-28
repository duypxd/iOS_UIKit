//
//  TermAndConditionTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import UIKit

class TermAndConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var tcViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        StyleHelper.commonLayer(layer: tcViewContainer.layer)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
