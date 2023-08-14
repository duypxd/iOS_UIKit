//
//  SafariWebView.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import UIKit
import SafariServices

class SafariWebViewHelper: NSObject {
    static func openSafariWebView(from viewController: UIViewController, withURL url: String) {
        guard let currentURL = URL(string: url) else {
            return
        }
        let safariVC = SFSafariViewController(url: currentURL)
        viewController.present(safariVC, animated: true, completion: nil)
    }
}
