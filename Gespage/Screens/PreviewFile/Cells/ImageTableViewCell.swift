//
//  ImageTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 10/08/2023.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fileImageView: UIImageView!
    
    func bind(url: URL) {
        if let image = UIImage(contentsOfFile: url.path) {
            fileImageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        StyleHelper.commonLayer(layer: containerView.layer)
        StyleHelper.commonLayer(layer: fileImageView.layer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
