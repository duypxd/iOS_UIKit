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
    
    func bind(_ printoutModel: PrintoutModelResponse, _ selectedIDs: [Int]) {
        printoutName.text = printoutModel.fileName
        printoutColor.text = String(printoutModel.colorPages)
        printoutBlackWhite.text = String(printoutModel.bwPages)
        prinoutPrice.text = Formater.formatAsUSD(amount: printoutModel.price)
        printoutDate.text = DateFormat.formatYYYYMMDD(printoutModel.date,outputFormat: "yyyy/MM/dd HH:mm")
        printoutStatus.text = printoutModel.status
        descriptionLabel.text = "printoutModel.description"
        
        printoutStatus(printoutModel.status)
        
        if selectedIDs.contains(printoutModel.printoutId) {
            printoutImage.image = UIImage(named: "printoutActive")
            printoutCheckbox.isHidden = false
            descriptionView.isHidden = false
            StyleHelper.applyCornerRadius(layer: printoutView.layer, corners: [.topLeft, .topRight], radius: 12)
        } else {
            printoutImage.image = UIImage(named: "printoutInActive")
            descriptionView.isHidden = true
            printoutCheckbox.isHidden = true
        }
    }
    
    private func printoutStatus(_ status: String) {
        // Status Printing
        switch status {
        case "pending":
            printoutDotView.isHidden = false
            printoutStatus.isHidden = false
            printoutStatus.textColor = UIColor(named: "alert")
            break
        case "completed":
            printoutDotView.isHidden = true
            printoutStatus.isHidden = true
            break
        case"printing":
            printoutDotView.isHidden = false
            printoutStatus.isHidden = false
            printoutStatus.textColor = UIColor(named: "primary600")
            break
        case "error":
            printoutDotView.isHidden = false
            printoutStatus.isHidden = false
            printoutStatus.textColor = UIColor(named: "error")
            break
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
        StyleHelper.applyCornerRadius(layer: printoutView.layer, corners: .allCorners, radius: 12)
        StyleHelper.applyCornerRadius(layer: descriptionView.layer, corners: [.bottomLeft, .bottomRight], radius: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
