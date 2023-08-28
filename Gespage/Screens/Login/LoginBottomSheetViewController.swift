//
//  LoginBottomSheetViewController.swift
//  Gespage
//
//  Created by Duy Pham on 05/08/2023.
//

import UIKit
import RxCocoa
import RxSwift

protocol LoginBottomSheetViewControllerDelegate: AnyObject {
    func didLoginSuccessfully()
}

class LoginBottomSheetViewController: UIViewController {
    weak var delegate: LoginBottomSheetViewControllerDelegate?

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iOSView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomSheetHeightConstraint: NSLayoutConstraint!
    
    var bottomSheetHeight: CGFloat = 0
    private var isSignedIn = false
    let disposeBag = DisposeBag()
    
    private var serverAddressChanged: String = ""
    private var usernameChanged: String = ""
    private var passwordChanged: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleHelper.commonLayer(layer: buttonView.layer)
        activityIndicator.isHidden = true
        // Init Tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
       
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
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - Submit
extension LoginBottomSheetViewController: UIViewControllerTransitioningDelegate {
    private func startLoading() {
        activityIndicator.isHidden = false
        buttonLogin.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.isHidden = true
        buttonLogin.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    @IBAction func onLogin(_ button: UIButton) {
        self.view.endEditing(true)
        if !validateForm([0, 1, 2]) {
            updateTableView()
            return
        } else {
            startLoading()
            APIManager.shared.performRequest(
                for: "/auth/login",
                method: .POST,
                requestModel: SignInModelRequest(username: usernameChanged, password: passwordChanged).self,
                responseType: UserCredentialModel.self
            )
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [self] result in
                switch result {
                case .success(let response):
                    stopLoading()
                    UserCredentialState.shared.saveUserCredential(response)
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.didLoginSuccessfully()
                case .failure(let error):
                    stopLoading()
                    
                    APIManager.shared.handlerError(error: error)
                }
            })
            .disposed(by: disposeBag)
        }
    }
}

// MARK: - Validation
extension LoginBottomSheetViewController {
    private func validateForm(_ rowIndexes: [Int]) -> Bool {
        var isValid = true

        for rowIndex in rowIndexes {
            var errorMessage = ""

            switch rowIndex {
            case 0:
                if serverAddressChanged.isEmpty {
                    isValid = false
                    errorMessage = "Gespage Server Address is required."
                }
            case 1:
                if usernameChanged.isEmpty {
                    isValid = false
                    errorMessage = "Username is required."
                }
            case 2:
                if passwordChanged.isEmpty {
                    isValid = false
                    errorMessage = "Password is required."
                }
            default:
                break
            }

            if !isValid {
                showErrorMessage(for: errorMessage, in: rowIndex)
            } else {
                showErrorMessage(for: nil, in: rowIndex)
            }
            self.updateTableView()
        }
        return isValid
    }


    private func showErrorMessage(for message: String? = nil, in row: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? TextFieldTableViewCell {
            let isHidden = message != nil && ((message?.isEmpty) == nil)
            cell.viewErrorMessage.isHidden = isHidden
            cell.errorMessageLabel.isHidden = isHidden
            cell.errorMessageLabel.text = message ?? nil
        }
    }
}

// MARK: - TableView Form Fields
extension LoginBottomSheetViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private func bindTextField(_ textField: UITextField, onChange: @escaping(String) -> Void) {
        textField.rx.text.orEmpty
            .distinctUntilChanged()  // Chỉ emit giá trị mới khi nó thay đổi
            .subscribe(onNext: { value in
                onChange(value)
            }).disposed(by: disposeBag)
    }
    
    private func configureCell(
        _ cell: TextFieldTableViewCell,
        title: String,
        placeholder: String,
        errorMessageLabel: String? = nil,
        isSecureTextEntry: Bool? = false,
        keyboardType: UIKeyboardType? = nil,
        onChange: @escaping (String) -> Void
    ) {
        cell.titleTextFieldLabel.text = title
        cell.textField.placeholder = placeholder
        cell.textField.keyboardType = keyboardType ?? .default
        cell.textField.returnKeyType = .done
        cell.textField.isSecureTextEntry = isSecureTextEntry ?? false
        cell.errorMessageLabel.text = errorMessageLabel
        bindTextField(cell.textField, onChange: onChange)
    }
    
    // Hide the keyboard when the "Return" key is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        cell.textField.delegate = self
        switch indexPath.row {
        case 0:
            configureCell(cell, title: "Gespage Server Address", placeholder: "Enter your server address", keyboardType: .URL) { value in
                self.serverAddressChanged = value
                let _ = self.validateForm([0])
            }
            break
        case 1:
            configureCell(cell, title: "Username", placeholder: "Enter your username") { value in
                self.usernameChanged = value
                let _ = self.validateForm([1])
            }
            break
        case 2:
            configureCell(cell, title: "Password", placeholder: "Enter your password", isSecureTextEntry: true) { value in
                self.passwordChanged = value
                let _ = self.validateForm([2])
            }
            break
        default:
            break
        }
        return cell
    }
}
