//
//  BottomSheetPresentationController.swift
//  Gespage
//
//  Created by Duy Pham on 05/08/2023.
//

import UIKit

class BottomSheetPresentationController: UIPresentationController {
    // Declare the overlay view for dimming effect
    private var overlayView: UIView!
    private let height: CGFloat?
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat?) {
        self.height = height
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        // Set the frame for the presented view (bottom sheet)
        guard let containerView = containerView, let height = height else { return CGRect.zero }
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        // Make sure the presented view fills the entire screen width
        presentedView?.frame = frameOfPresentedViewInContainerView
        overlayView?.frame = containerView?.bounds ?? CGRect.zero
    }
    
    override func presentationTransitionWillBegin() {
        // Add the presented view to the container view
        containerView?.addSubview(presentedView!)
        
        // Create and add the overlay view with initial alpha 0.0
        overlayView = UIView(frame: containerView?.bounds ?? CGRect.zero)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        overlayView.addGestureRecognizer(tapGesture)
        containerView?.insertSubview(overlayView, at: 0)
        
        // Animate the presentation with a fade-in effect for the overlayView
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.overlayView.alpha = 1
            }, completion: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        // Animate the dismissal with a fade-out effect for the overlayView
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.overlayView.alpha = 0.0
            }, completion: nil)
        }
        // Remove keyboard notification observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissBottomSheet() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardY = keyboardFrame.origin.y
            let newFrameY = keyboardY - (height ?? 0)

            if let containerView = containerView {
                presentedView?.frame = CGRect(x: 0, y: newFrameY, width: containerView.bounds.width, height: height ?? 0)
            }
        }
    }

    // Function to adjust the frame of the bottom sheet when the keyboard disappears
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let containerView = containerView {
            presentedView?.frame = CGRect(x: 0, y: containerView.bounds.height - (height ?? 0), width: containerView.bounds.width, height: height ?? 0)
        }
    }
    
}

