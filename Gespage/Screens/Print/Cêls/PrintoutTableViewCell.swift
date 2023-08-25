//
//  PrintoutTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 07/08/2023.
//

import UIKit

class PrintoutTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var printoutView: UIView!
    @IBOutlet weak var printoutImage: UIImageView!
    @IBOutlet weak var printoutName: UILabel!
    @IBOutlet weak var printoutCheckbox: UIImageView!
    @IBOutlet weak var printoutDate: UILabel!
    @IBOutlet weak var printoutColor: UILabel!
    @IBOutlet weak var printoutBlackWhite: UILabel!
    @IBOutlet weak var prinoutPrice: UILabel!
    @IBOutlet weak var printoutDotView: UIImageView!
    @IBOutlet weak var printoutStatus: UILabel!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func bind(printoutModel: PrintoutModelResponse) {
        printoutName.text = printoutModel.fileName
        printoutColor.text = String(printoutModel.colorPages)
        printoutBlackWhite.text = String(printoutModel.bwPages)
        prinoutPrice.text = Formater.formatAsUSD(amount: printoutModel.price)
        printoutDate.text = DateFormat.formatYYYYMMDD(printoutModel.date,outputFormat: "yyyy/MM/dd HH:mm")
        printoutStatus.text = printoutModel.status
        descriptionLabel.text = "printoutModel.description"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        StyleHelper.applyCornerRadius(layer: printoutView.layer, corners: .allCorners, radius: 12)
        StyleHelper.applyCornerRadius(layer: descriptionView.layer, corners: [.bottomLeft, .bottomRight], radius: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
