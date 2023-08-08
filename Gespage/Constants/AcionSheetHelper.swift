//
//  AcionSheetHelper.swift
//  Gespage
//
//  Created by Duy Pham on 08/08/2023.
//

import UIKit

class ActionSheetHelper {
    static func showActionSheet(with actions: [UIAlertAction], message: String, from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        // Thêm các tùy chọn từ mảng vào Action Sheet
        for action in actions {
            alertController.addAction(action)
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelOption)
        
        // Hiển thị Action Sheet trên màn hình
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
