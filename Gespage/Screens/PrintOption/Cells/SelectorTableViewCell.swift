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
