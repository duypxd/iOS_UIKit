//
//  AboutViewController.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import UIKit
import RxCocoa
import RxSwift

struct AboutItemModel {
    let identifier: String
    let title: String
    var subTitle: String
}

class AboutViewController: UIViewController {
    enum TableViewCellIdentifier {
        case aboutItem(model: AboutItemModel)
        case termAndCondition(model: AboutItemModel)
        
        var model: AboutItemModel {
            switch self {
            case .aboutItem(let model), .termAndCondition(let model):
                return model
            }
        }
    }

    var cellIdentifiers: [TableViewCellIdentifier] = [
        .aboutItem(
            model: AboutItemModel(
                identifier: "AboutTableViewCell",
                title: "App Version",
                subTitle: "1.0.0"
            )
        ),
        .aboutItem(
            model: AboutItemModel(
                identifier: "AboutTableViewCell",
                title: "Gespage sever address",
                subTitle: "https://mobile-app.gespage.com:8443"
            )
        ),
        .termAndCondition(
            model: AboutItemModel(
                identifier: "TermAndConditionTableViewCell",
                title: "Terms & Conditions",
                subTitle: ""
            )
        )
    ]
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var disposed = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissionSignIn()
        
        tableView.delegate = self
        tableView.dataSource = self

        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier.model.identifier, bundle: nil), forCellReuseIdentifier: cellIdentifier.model.identifier)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - APIs
extension AboutViewController {
    private func checkPermissionSignIn() {
        UserCredentialState.shared.userCredential
            .subscribe(onNext: { [weak self] user in
                var gespageServerModel = self?.cellIdentifiers[1].model
                if user != nil {
                    self?.updateAboutItem(1, "https://mobile-app.gespage.com:8443")
                } else {
                    self?.updateAboutItem(1, "N/A")
                    self?.cellIdentifiers.remove(at: 2)
                }
                self?.tableView?.reloadData()
            })
            .disposed(by: disposed)
    }
    
    private func updateAboutItem(_ indexPath: Int, _ subTitle: String) {
        if case .aboutItem(var model) = cellIdentifiers[indexPath] {
            model.subTitle = subTitle
            cellIdentifiers[indexPath] = .aboutItem(model: model)
        }
    }
}

// MARK: - @IBActions
extension AboutViewController {
    @IBAction func buttonBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView
extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = cellIdentifiers[indexPath.row]
        
        switch cellIdentifier {
        case .aboutItem(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as! AboutTableViewCell
            cell.bind(title: model.title, subTitle: model.subTitle)
            return cell
            
        case .termAndCondition(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as! TermAndConditionTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            SafariWebViewHelper.openSafariWebView(from: self, withURL: "https://www.africau.edu/images/default/sample.pdf")
        }
    }
}
