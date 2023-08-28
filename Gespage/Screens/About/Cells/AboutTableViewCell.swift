//
//  AboutTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutViewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    func bind(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        StyleHelper.commonLayer(layer: aboutViewContainer.layer)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
