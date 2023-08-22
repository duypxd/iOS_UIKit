//
//  DialogReleaseViewController.swift
//  Gespage
//
//  Created by duy.pham on 21/08/2023.
//

import UIKit

class DialogReleaseViewController: UIViewController {

    @IBOutlet weak var heightDialog: NSLayoutConstraint!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var printerNameLabel: UILabel!
    @IBOutlet weak var printerIdLabel: UILabel!
    @IBOutlet weak var printerStatusLabel: UILabel!
    @IBOutlet weak var documentsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var receivedPrintouts: [PrintoutModelResponse] = []
    var receivedPrinter: PrinterModel?
    var onConfirmed: (() -> Void)?
    
    func showDialog(
        printouts: [PrintoutModelResponse],
        priner: PrinterModel,
        onConfirm: (() -> Void)?
    ) {
        receivedPrinter = priner
        receivedPrintouts = printouts
        self.onConfirmed = onConfirm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LabelDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelDocumentTableViewCell")
        
        StyleHelper.commonLayer(layer: dialogView.layer)
        
        printerNameLabel.text = receivedPrinter?.name
        printerIdLabel.text = receivedPrinter?.printerId
        documentsLabel.text = "Document release (\(receivedPrintouts.count))"
        // Status Style
        printerStatusLabel.text = receivedPrinter?.status
        if receivedPrinter?.status == "Available" {
            printerStatusLabel.textColor = UIColor(named: "sencondary600")
        } else {
            printerStatusLabel.textColor = UIColor(named: "alert")
            confirmButton.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
            confirmButton.isEnabled = false
        }
        // Buttons Style
        confirmButton.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = tableView.contentSize.height
        tableView.isScrollEnabled = tableViewHeight > 136
        heightDialog.constant = (tableViewHeight > 136 ? 136 : tableViewHeight) + 330
    }
    
    @IBAction func buttonConfirmAction(_ sender: UIButton) {
        onConfirmed?()
    }
    
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - tablebiew

extension DialogReleaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedPrintouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelDocumentTableViewCell", for: indexPath) as! LabelDocumentTableViewCell
        cell.fileNameLabel.text = receivedPrintouts[indexPath.row].fileName
        cell.priceLabel.text = Formater.formatAsUSD(amount: receivedPrintouts[indexPath.row].price)
        return cell
    }
    
}
