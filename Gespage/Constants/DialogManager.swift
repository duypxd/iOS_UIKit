//
//  DialogConfirmManager.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import UIKit

class DialogManager {
    static let shared = DialogManager()

    func showConfirmDialog(
        from viewController: UIViewController,
        title: String,
        message: String,
        labelConfirm: String,
        backgroundColorConfirm: UIColor,
        onConfirm: @escaping () -> Void
    ) {
        let storyboard = UIStoryboard(name: "DialogConfirmStoryboard", bundle: nil)
        guard let dialogVC = storyboard.instantiateViewController(withIdentifier: "DialogConfirmViewController") as? DialogConfirmViewController else {
            return
        }
        dialogVC.showDialog(
            title: title,
            message: message,
            labelConfirm: labelConfirm,
            backgroundColorConfirm: backgroundColorConfirm,
            onConfirm: onConfirm
        )
        viewController.view.endEditing(true)
        dialogVC.modalPresentationStyle = .custom
        dialogVC.transitioningDelegate = (viewController.self as! any UIViewControllerTransitioningDelegate)
        viewController.present(dialogVC, animated: true, completion: nil)
    }
    
    func showSuccessDialog(
        from viewController: UIViewController,
        title: String,
        message: String,
        labelButton: String,
        onConfirm: @escaping () -> Void
    ) {
        let storyboard = UIStoryboard(name: "DialogSuccessStoryboard", bundle: nil)
        guard let dialogVC = storyboard.instantiateViewController(withIdentifier: "DialogSuccessViewController") as? DialogSuccessViewController else {
            return
        }
        dialogVC.showDialog(
            title: title,
            message: message,
            labelButton: labelButton,
            onConfirm: onConfirm
        )
        viewController.view.endEditing(true)
        dialogVC.modalPresentationStyle = .custom
        dialogVC.transitioningDelegate = (viewController.self as! any UIViewControllerTransitioningDelegate)
        viewController.present(dialogVC, animated: true, completion: nil)
    }
}
