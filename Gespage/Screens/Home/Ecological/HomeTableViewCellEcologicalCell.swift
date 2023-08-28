//
//  HomeTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 01/08/2023.
//

import UIKit

class HomeTableViewCellEcologicalCell: UITableViewCell {

    @IBOutlet weak var greenScoreView: UIView!
    @IBOutlet weak var savedWaterView: UIView!
    @IBOutlet weak var savedTreesView: UIView!
    
    @IBOutlet weak var savedTressLabel: UILabel!
    @IBOutlet weak var savedWaterLabel: UILabel!
    @IBOutlet weak var GreenCoreLabel: UILabel!
    
    func bind(_ statsModel: StatsModelResponse?) {
        savedTressLabel.text = "\(statsModel?.savedTrees ?? 0)"
        savedWaterLabel.text = "\(statsModel?.savedWater ?? 0)"
        GreenCoreLabel.text = "\(Int(statsModel?.ecologicalTrend ?? 0.0))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear

        StyleHelper.commonLayer(layer: savedTreesView.layer)
        StyleHelper.commonLayer(layer: savedWaterView.layer)
        StyleHelper.commonLayer(layer: greenScoreView.layer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
