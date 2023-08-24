//
//  MoreViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit
import SafariServices
import RxCocoa
import RxSwift

class MoreViewController: UIViewController {
    
    // Init User Model

    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var userCredential: UserCredentialModel?
    let disposed = DisposeBag()
    var isDialog = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserCredentialState.shared.userCredential.subscribe(onNext: { [weak self] user in
            self?.userCredential = user
            self?.tableView?.reloadData()
            
            // Hide UI
            self?.buttonLogout.isHidden = user == nil
        }).disposed(by: disposed)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        buttonLogout.layer.cornerRadius = 12
        buttonLogout.layer.borderWidth = 1
        buttonLogout.layer.borderColor = UIColor(named: "primary600")?.cgColor
        
        let cellIdentifiers = [
            "MenuItemProfileTableViewCell",
            "MenuItemTableViewCell"
        ]
        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }
}

// MARK: - @IBAction
extension MoreViewController {
    @IBAction func buttonLogoutAction(_ sender: Any) {
        DialogManager.shared.showConfirmDialog(
            from: self,
            title: "Logout",
            message: "Are you sure you want to log out?",
            labelConfirm: "Log out",
            backgroundColorConfirm: UIColor(named: "error")!,
            onConfirm: {
                UserCredentialState.shared.deleteUserCredential()
                self.dismiss(animated: true, completion: nil)
            }
        )
    }
}

// MARK: - Table view
extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellMenuItem = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
        cellMenuItem.viewContainer.layer.cornerRadius = 8
        
        switch indexPath.row {
        case 0:
            let cellMenuProfile = tableView.dequeueReusableCell(withIdentifier: "MenuItemProfileTableViewCell", for: indexPath) as! MenuItemProfileTableViewCell
            cellMenuProfile.viewContainer.layer.cornerRadius = 8
            cellMenuProfile.labelFullName.text = userCredential?.fullName ?? "Login"
            cellMenuProfile.labelEmail.text = userCredential?.email ?? "Please login to view Profile"
            return cellMenuProfile
        case 1:
            cellMenuItem.label.text = "Account top up"
            cellMenuItem.firstIcon.image = UIImage(named: "creditCard")
            return cellMenuItem
        case 2:
            cellMenuItem.label.text = "Contact support"
            cellMenuItem.firstIcon.image = UIImage(named: "chatCircleDots")
            return cellMenuItem
        case 3:
            cellMenuItem.label.text = "About"
            cellMenuItem.firstIcon.image = UIImage(named: "info")
            return cellMenuItem
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if userCredential == nil {
                self.openBottomSheetLogin()
            } else {
                let storyboard = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
                if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                    profileVC.userCredential = userCredential
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
            break
        case 1:
            SafariWebViewHelper.openSafariWebView(from: self, withURL: "https://google.com.vn")
            break
        case 2:
            DialogManager.shared.showConfirmDialog(
                from: self,
                title: "Support",
                message: "Contact support: \(String(describing: userCredential?.supportEmail))",
                labelConfirm: "Contact",
                backgroundColorConfirm: UIColor(named: "primary600")!,
                onConfirm: {
                    EmailManager.shared.openEmailApp(to: self.userCredential?.supportEmail ?? "")
                    self.dismiss(animated: true, completion: nil)
                }
            )
            break
        case 3:
            let storyboard = UIStoryboard(name: "AboutStoryboard", bundle: nil)
            if let aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController {
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }
            break
        default:
            break
        }
    }
}

// MARK: - LoginBottomSheetViewControllerDelegate
extension MoreViewController: UIViewControllerTransitioningDelegate, LoginBottomSheetViewControllerDelegate {
    func openBottomSheetLogin() {
        isDialog = false
        LoginManager.presentBottomSheet(from: self, delegate: self)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if isDialog {
            return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: 180, isDialog: true)
        }
        return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: isDialog ? 180 :(presented as? LoginBottomSheetViewController)?.bottomSheetHeight, isDialog: isDialog)
    }
    
    func didLoginSuccessfully() {
        isDialog = true
        self.dismiss(animated: true, completion: nil)
    }
}
