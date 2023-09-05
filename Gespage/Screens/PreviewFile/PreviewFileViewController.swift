//
//  PreviewFileViewController.swift
//  Gespage
//
//  Created by Duy Pham on 09/08/2023.
//

import UIKit

class PreviewFileViewController: UIViewController {
    var receivedPaths: [URL] = []
    var documentController: UIDocumentInteractionController?


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellIdentifiers = [
            "FileTableViewCell",
            "ImageTableViewCell"
        ]
        
        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        
        bottomBarView.layer.cornerRadius = 16
        bottomBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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

// MARK: - @IBAction
extension PreviewFileViewController {
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonShareAction(_ sender: UIButton) {
    }
    
    @IBAction func printButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "PrintOptionStoryboard", bundle: nil)
        if let printOptionVC = storyboard.instantiateViewController(withIdentifier: "PrintOptionViewController") as? PrintOptionViewController {
            printOptionVC.receivedPaths = receivedPaths.map{ $0.path }
            navigationController?.pushViewController(printOptionVC, animated: true)
        }
    }
}

// MARK: - TableView
extension PreviewFileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedPaths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let url = receivedPaths[indexPath.row]
        
        if FileSystemHelper.isImageFile(atPath: url.path) {
            let cellImage = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cellImage.bind(url: url)
            return cellImage
        } else {
            let cellFile = tableView.dequeueReusableCell(withIdentifier: "FileTableViewCell", for: indexPath) as! FileTableViewCell
            cellFile.bind(url: url)
            return cellFile
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = receivedPaths[indexPath.row]
        openFileButtonTapped(url)
    }
}

// MARK: - Open File
extension PreviewFileViewController: UIDocumentInteractionControllerDelegate {
    private func openFileButtonTapped(_ url: URL) {
        documentController = UIDocumentInteractionController(url: url)
        documentController?.delegate = self
        documentController?.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
