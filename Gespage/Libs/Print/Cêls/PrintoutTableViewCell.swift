//
//  PrintoutTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 07/08/2023.
//

import UIKit

class PrintoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var printoutView: UIView!
    @IBOutlet weak var printoutName: UILabel!
    @IBOutlet weak var printoutDate: UILabel!
    @IBOutlet weak var printoutColor: UILabel!
    @IBOutlet weak var printoutBlackWhite: UILabel!
    @IBOutlet weak var prinoutPrice: UILabel!
    @IBOutlet weak var printoutDotView: UIImageView!
    @IBOutlet weak var printoutStatus: UILabel!
    @IBOutlet weak var printoutCheckbox: UIImageView!
    @IBOutlet weak var printoutImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonLayer(layer: printoutView.layer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


// MARK: - Card
extension PrintoutTableViewCell {
    private func commonLayer(layer: CALayer) {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.1
    }
}
