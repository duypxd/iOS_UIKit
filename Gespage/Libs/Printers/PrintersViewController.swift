//
//  PrintersViewController.swift
//  Gespage
//
//  Created by Duy Pham on 03/08/2023.
//

import UIKit

class PrintersViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
}

// MARK: Life Cycle
extension PrintersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "PrinterTableViewCell")
        
        
        navigationController?.navigationBar.isHidden = true
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

// MARK: - Table View Printers
extension PrintersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MockData.dataPrinters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterTableViewCell", for: indexPath) as! PrinterTableViewCell
        
        let printerModel = MockData.dataPrinters[indexPath.row];
        
        cell.printerId.text = printerModel.printerId
        cell.printerName.text = printerModel.name
        cell.printerStatus.text = printerModel.status
        
        if printerModel.status == "Available" {
            cell.printerStatus.textColor = UIColor(named: "sencondary600")
            cell.iconPrinter.tintColor = UIColor(named: "primary600")
        } else {
            cell.printerStatus.textColor = UIColor(named: "alert")
        }
        
        return cell
    }
}

// MARK: - @IBOutlet
extension PrintersViewController {
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
