//
//  MoreViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit
import SafariServices

class MoreViewController: UIViewController {
    
    // Init User Model

    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var userModel = UserModel(
        username: "duypham",
        email: "duy.pham+1@team.enouvo.com",
        fullName: "Duy Pham",
        printCode: "12345678",
        userCredit: 999999,
        limited: true,
        currency: "EUR",
        department: "eNouvo",
        reloadable: true,
        supportEmail: "test_gespage_support@gmail.com",
        paperFormats: [
            "A3",
            " A4",
            " A5"
          ]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.dismiss(animated: true, completion: nil)
            }
        )
    }
}

// MARK: - DialogPresentationController
extension MoreViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: 180, isDialog: true)
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
            cellMenuProfile.labelFullName.text = userModel.fullName
            cellMenuProfile.labelEmail.text = userModel.email
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
            let storyboard = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
            if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                profileVC.userModel = userModel
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            break
        case 1:
            SafariWebViewHelper.openSafariWebView(from: self, withURL: "https://google.com.vn")
            break
        case 2:
            DialogManager.shared.showConfirmDialog(
                from: self,
                title: "Support",
                message: "Contact support: \(userModel.supportEmail)",
                labelConfirm: "Contact",
                backgroundColorConfirm: UIColor(named: "primary600")!,
                onConfirm: {
                    EmailManager.shared.openEmailApp(to: "duy.pham@team.enouvo.com")
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
