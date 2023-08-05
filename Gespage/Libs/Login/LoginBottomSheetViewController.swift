//
//  LoginBottomSheetViewController.swift
//  Gespage
//
//  Created by Duy Pham on 05/08/2023.
//

import UIKit
protocol LoginBottomSheetViewControllerDelegate: AnyObject {
    func didLoginSuccessfully()
}

class LoginBottomSheetViewController: UIViewController {
    weak var delegate: LoginBottomSheetViewControllerDelegate?
    
    @IBOutlet weak var textFieldServerAddress: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var iOSView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomSheetHeightConstraint: NSLayoutConstraint!
    
    var bottomSheetHeight: CGFloat = 0
}

// MARK: - Onchange TextField
extension LoginBottomSheetViewController: UIViewControllerTransitioningDelegate {
    @IBAction func onChangeServerAddress(_ textField: UITextField) {
        textFieldServerAddress.text = textField.text ?? ""
    }
    
    @IBAction func onChangeUsername(_ textField: UITextField) {
        textFieldUsername.text = textField.text ?? ""
    }
    
    @IBAction func onChangePassword(_ textField: UITextField) {
        textFieldPassword.text = textField.text ?? ""
    }

    @IBAction func onLogin(_ button: UIButton) {
        
        textFieldResignFirstResponder()
        let bodyRequest = LoginRequestModel(
            serverAddress: textFieldServerAddress.text ?? "", username: textFieldUsername.text ?? "", password: textFieldPassword.text ?? ""
        )
        self.dismiss(animated: true, completion: nil)
        delegate?.didLoginSuccessfully()
    }
    
    // Hide the keyboard when the "Return" key is tapped
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textFieldResignFirstResponder()
       return true
   }
    
    func textFieldResignFirstResponder() {
        textFieldServerAddress.resignFirstResponder()
        textFieldUsername.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
}

// MARK: - Life Cycle
extension LoginBottomSheetViewController: UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldServerAddress.delegate = self
        textFieldUsername.delegate = self
        textFieldPassword.delegate = self
       
        setUpLoginBottomSheet()
        setupBorderRadiusBottomSheet()
        setUpContentViewBottomSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Animate the appearance of the overlayView
        self.view.subviews.first?.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.view.subviews.first?.alpha = 1.0
        }
    }
}

// MARK: - Setup BottomSheet
extension LoginBottomSheetViewController {
    
    func setupBorderRadiusBottomSheet() {
        let cornerRadius: CGFloat = 12
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner]
        bottomSheetView.layer.cornerRadius = cornerRadius
        bottomSheetView.layer.maskedCorners.insert(.layerMaxXMinYCorner)
        view.addSubview(bottomSheetView)
    }
    
    func setUpContentViewBottomSheet() {
        iOSView.layer.cornerRadius = 3
    }
    
    func setUpLoginBottomSheet() {
        // Setup the appearance of the bottom sheet
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 400)
        view.layer.cornerRadius = 10.0
    }
}
