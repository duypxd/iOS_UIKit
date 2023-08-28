//
//  SignInBannerTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 04/08/2023.
//

import UIKit
protocol SignInBannerTableViewCellDelegate: AnyObject {
    func openBottomSheetLogin()
}

class SignInBannerTableViewCell: UITableViewCell {
    weak var delegate: SignInBannerTableViewCellDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iOSView: UIView!
    
    @IBOutlet weak var onLogin: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showBottomSheet(_ sender: UIButton) {
        delegate?.openBottomSheetLogin()
    }
}

class BottomSheetViewController: UIViewController {
    // Các thành phần giao diện của bottom sheet
    // ...

    override func viewDidLoad() {
        super.viewDidLoad()
        // Cấu hình giao diện và các xử lý khác tại đây
    }
}
