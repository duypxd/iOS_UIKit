//
//  EmailHelper.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import UIKit
import MessageUI

class EmailManager: NSObject, MFMailComposeViewControllerDelegate {
    static let shared = EmailManager()

    func openEmailApp(to email: String) {
        guard MFMailComposeViewController.canSendMail() else { return }
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.setToRecipients([email])
        UIApplication.topViewController()?.present(mailComposeVC, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
