//
//  SelectorTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 15/08/2023.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var selectorView: UIView!
    
    var tapAction: (() -> Void)? // Closure to handle the tap action
    
    func bind(indexPath: IndexPath, printoutModelRequest: PrintoutModelRequest?) {
        switch indexPath.row {
        case 1:
            titleLabel?.text = "Orientation"
            selectorLabel.text = printoutModelRequest?.landscape == true ? MockDataPrintout.dataLandscape.last : MockDataPrintout.dataLandscape.first
        case 2:
            titleLabel?.text = "Color"
            selectorLabel.text = printoutModelRequest?.color == true ? MockDataPrintout.dataColors.first : MockDataPrintout.dataColors.last
        case 3:
            titleLabel?.text = "Two-side"
            selectorLabel.text = printoutModelRequest?.duplex == true ? MockDataPrintout.dataTwoSide.first : MockDataPrintout.dataTwoSide.last
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        StyleHelper.selectorLayer(layer: selectorView.layer)
        
        // Add tap gesture recognizer to selectorView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectorViewTapped))
        selectorView.addGestureRecognizer(tapGesture)
    }

    @objc func selectorViewTapped() {
        tapAction?() // Call the closure when selectorView is tapped
    }
}
