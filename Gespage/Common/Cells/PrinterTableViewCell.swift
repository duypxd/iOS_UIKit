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
    @IBOutlet weak var iconPrinter: UIImageView!
    
    func bind(printerModel: PrinterModel) {
        printerId.text = String(printerModel.printerId)
        printerName.text = printerModel.printerName
        printerStatus.text = printerModel.printerStatus == 0 ? "Available" : "UnAvailable"
        if printerModel.printerStatus == 0 {
            printerStatus.textColor = UIColor(named: "sencondary600")
            iconPrinter.tintColor = UIColor(named: "primary600")
        } else {
            printerStatus.textColor = UIColor(named: "alert")
            iconPrinter.tintColor = UIColor(named: "greyG300")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewIconPrinter.layer.cornerRadius = 8
        StyleHelper.commonLayer(layer: printerViewContainer.layer)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
