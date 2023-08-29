//
//  ManagerAlertLoading.swift
//  Gespage
//
//  Created by duy.pham on 29/08/2023.
//

import UIKit

class ManagerAlert {
    static func showLoading(in viewController: UIViewController, message: String? = "Loading...") {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func dismissLoading(in viewController: UIViewController) {
        DispatchQueue.main.async {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
