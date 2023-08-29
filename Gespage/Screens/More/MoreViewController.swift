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

struct MenuItemModel {
    let identifier: String
    let label: String
    let iconName: String
}

enum TableViewCellIdentifier {
    case profile(model: MenuItemModel)
    case menuItem(model: MenuItemModel)
    
    var model: MenuItemModel {
        switch self {
        case .profile(let model), .menuItem(let model):
            return model
        }
    }
}

class MoreViewController: UIViewController {
    let initCellIdentifiers: [TableViewCellIdentifier] = [
        .profile(model: MenuItemModel(identifier: "MenuItemProfileTableViewCell", label: "Login", iconName: "")),
        .menuItem(model: MenuItemModel(identifier: "MenuItemTableViewCell", label: "About", iconName: "info"))
    ]
    var cellIdentifiers: [TableViewCellIdentifier] = []
    
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var userCredential: UserCredentialModel?
    let disposed = DisposeBag()
    var isDialog = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellIdentifiers = initCellIdentifiers
        
        checkPermissionSignIn()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        buttonLogout.layer.cornerRadius = 12
        buttonLogout.layer.borderWidth = 1
        buttonLogout.layer.borderColor = UIColor(named: "primary600")?.cgColor
        
        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier.model.identifier, bundle: nil), forCellReuseIdentifier: cellIdentifier.model.identifier)
        }
    }
}

// MARK: - APIs
extension MoreViewController {
    @IBAction func checkPermissionSignIn() {
        UserCredentialState.shared.userCredential.subscribe(onNext: { [weak self] user in
            self?.userCredential = user
            self?.insertCellToTableView()
            
            self?.tableView?.reloadData()
            self?.buttonLogout.isHidden = user == nil
        }).disposed(by: disposed)
    }
    
    @IBAction func buttonLogoutAction(_ sender: Any) {
        DialogManager.shared.showConfirmDialog(
            from: self,
            title: "Logout",
            message: "Are you sure you want to log out?",
            labelConfirm: "Log out",
            backgroundColorConfirm: UIColor(named: "error")!,
            onConfirm: {
                APIManager.shared.deleteCookies()
                UserCredentialState.shared.deleteUserCredential()
                self.dismiss(animated: true, completion: nil)
            }
        )
    }
    
    private func insertCellToTableView() {
        if userCredential != nil {
            let newElements: [TableViewCellIdentifier] = [
                .menuItem(model: MenuItemModel(identifier: "MenuItemTableViewCell", label: "Account top up", iconName: "creditCard")),
                .menuItem(model: MenuItemModel(identifier: "MenuItemTableViewCell", label: "Contact support", iconName: "chatCircleDots")),
            ]
           cellIdentifiers.insert(contentsOf: newElements, at: 1)
        } else {
            if cellIdentifiers.count == 4 {
                let indexsToRemove = [1, 2]
                cellIdentifiers = cellIdentifiers.enumerated().filter {
                    !indexsToRemove.contains($0.offset)
                }.map { $0.element }
            }
        }
    }
}

// MARK: - Table view
extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = cellIdentifiers[indexPath.row]
        
        switch cellIdentifier {
        case .profile(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as! MenuItemProfileTableViewCell
            cell.bind(
                fullName: userCredential?.fullName ?? model.label,
                email: userCredential?.email ?? "Please login to view Profile"
            )
            return cell
            
        case .menuItem(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as! MenuItemTableViewCell
            cell.bind(labelName: model.label, iconName: model.iconName)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIdentifier = cellIdentifiers[indexPath.row]
        switch cellIdentifier {
            
        case .profile(model:_):
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
        case .menuItem(model: let model):
            switch model.iconName {
            case "creditCard":
                SafariWebViewHelper.openSafariWebView(from: self, withURL: "https://google.com.vn")
                break
            case "chatCircleDots":
                DialogManager.shared.showConfirmDialog(
                    from: self,
                    title: "Support",
                    message: "Contact support: \(self.userCredential?.supportEmail ?? "")",
                    labelConfirm: "Contact",
                    backgroundColorConfirm: UIColor(named: "primary600")!,
                    onConfirm: {
                        EmailManager.shared.openEmailApp(to: self.userCredential?.supportEmail ?? "")
                        self.dismiss(animated: true, completion: nil)
                    }
                )
                break
            case "info":
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
        return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: (presented as? LoginBottomSheetViewController)?.bottomSheetHeight, isDialog: isDialog)
    }
    
    func didLoginSuccessfully() {
        isDialog = true
        self.dismiss(animated: true, completion: nil)
    }
}
