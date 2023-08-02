//
//  PrinterTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 02/08/2023.
//

import UIKit

class PrinterTableViewCell: UITableViewCell {

    @IBOutlet weak var printerViewContainer: UIView!
    @IBOutlet weak var viewIconPrinter: UIView!
    @IBOutlet weak var printerName: UILabel!
    @IBOutlet weak var printerId: UILabel!
    @IBOutlet weak var printerStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewIconPrinter.layer.cornerRadius = 8
        commonLayer(layer: printerViewContainer.layer)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Card - HomeTableViewCellEcologicalCell
extension PrinterTableViewCell {
    private func commonLayer(layer: CALayer) {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.1
    }
}
