//
//  BalanceTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 04/08/2023.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    func bind(userCredential: UserCredentialModel?) {
        username.text = userCredential?.fullName ?? "Gespage User"
        balance.text = Formater.formatAsUSD(amount: userCredential?.userCredit ?? 0.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
