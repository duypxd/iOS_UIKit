//
//  AboutViewController.swift
//  Gespage
//
//  Created by Duy Pham on 14/08/2023.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellIdentifiers = [
            "AboutTableViewCell",
            "TermAndConditionTableViewCell"
        ]

        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
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

// MARK: - @IBActions
extension AboutViewController {
    @IBAction func buttonBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView
extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aboutCell = tableView.dequeueReusableCell(withIdentifier: "AboutTableViewCell", for: indexPath) as! AboutTableViewCell
        StyleHelper.commonLayer(layer: aboutCell.aboutViewContainer.layer)
        
        switch indexPath.row {
        case 0:
            aboutCell.titleLabel.text = "App Version"
            aboutCell.subTitleLabel.text = "V1.0.0(1)"
            return aboutCell
        case 1:
            aboutCell.titleLabel.text = "Gespage sever address"
            aboutCell.subTitleLabel.text = "htps://mobile-app.gespage.com:8443"
            return aboutCell
        case 2:
            let tcCell = tableView.dequeueReusableCell(withIdentifier: "TermAndConditionTableViewCell", for: indexPath) as! TermAndConditionTableViewCell
            StyleHelper.commonLayer(layer: tcCell.tcViewContainer.layer)
            return tcCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            SafariWebViewHelper.openSafariWebView(from: self, withURL: "https://www.africau.edu/images/default/sample.pdf")
        }
    }
}
