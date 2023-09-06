//
//  ManagerAlertLoading.swift
//  Gespage
//
//  Created by duy.pham on 29/08/2023.
//

import UIKit

class ManagerAlert {
    static let shared = ManagerAlert()
    private init() {}

    private var loadingAlert: UIAlertController?

    func showLoading(in viewController: UIViewController, message: String? = "Loading...") {
        if loadingAlert == nil {
            loadingAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()
            loadingAlert?.view.addSubview(loadingIndicator)
        }
        viewController.present(loadingAlert!, animated: true, completion: nil)
    }

    func dismissLoading() {
        DispatchQueue.main.async {
            self.loadingAlert?.dismiss(animated: true, completion: nil)
            self.loadingAlert = nil
        }
    }
}
