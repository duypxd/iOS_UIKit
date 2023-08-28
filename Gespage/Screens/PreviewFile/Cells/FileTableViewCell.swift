//
//  FileTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 10/08/2023.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fileTextView: UIView!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    func bind(url: URL) {
        fileNameLabel.text = url.lastPathComponent
        fileSizeLabel.text = ImageHelper.fileSizeString(fromAbsoluteURL: url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        StyleHelper.commonLayer(layer: containerView.layer)
        StyleHelper.commonLayer(layer: fileTextView.layer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
