//
//  PrintersViewController.swift
//  Gespage
//
//  Created by Duy Pham on 03/08/2023.
//

import UIKit

class PrintersViewController: UIViewController {
    
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    
    var receivedTitle: String?
    var receivedPrintouts: [PrintoutModelResponse] = []
}

// MARK: Life Cycle
extension PrintersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        titlePage.text = receivedTitle
        
        // register Cells
        tableView.register(UINib(nibName: "PrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "PrinterTableViewCell")
        tableView.register(UINib(nibName: "EmptyPrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyPrinterTableViewCell")
        // Hide Header Default
        navigationController?.navigationBar.isHidden = true
        
        // Refresh
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Stop the refresh control
            self.refreshControl.endRefreshing()

            // Scroll to the top of the table view
            let topIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
    }
}

// MARK: - Table View Printers
extension PrintersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MockData.dataPrinters.isEmpty {
            return 1
        } else {
            return MockData.dataPrinters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if MockData.dataPrinters.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyPrinterTableViewCell", for: indexPath) as! EmptyPrinterTableViewCell
            cell.backgroundColor = .clear
            return cell;
        } else {
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
                cell.iconPrinter.tintColor = UIColor(named: "greyG300")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !receivedPrintouts.isEmpty {
            DialogManager.shared.showConfirmReleaseDialog(
                from: self,
                printouts: receivedPrintouts,
                priner: MockData.dataPrinters[indexPath.row],
                onConfirm: {[self] in
                    dismiss(animated: true, completion: nil)
                }
            )
        }
    }
}

// MARK: - @IBOutlet
extension PrintersViewController {
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - DialogPresentationController
extension PrintersViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: 466, isDialog: true)
    }
}
