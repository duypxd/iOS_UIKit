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
        printer: PrinterModel,
        onConfirm: (() -> Void)?
    ) {
        receivedPrinter = printer
        receivedPrintouts = printouts
        self.onConfirmed = onConfirm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpUI()
        bindingData()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = tableView.contentSize.height
        tableView.isScrollEnabled = tableViewHeight > 136
        heightDialog.constant = (tableViewHeight > 136 ? 136 : tableViewHeight) + 330
    }
}

// MARK: - Functions
extension DialogReleaseViewController {
    @IBAction func buttonConfirmAction(_ sender: UIButton) {
        onConfirmed?()
    }
    
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LabelDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelDocumentTableViewCell")
    }
    
    private func bindingData() {
        printerNameLabel.text = receivedPrinter?.printerName
        printerIdLabel.text = receivedPrinter?.printerId
        documentsLabel.text = "Document release (\(receivedPrintouts.count))"
        // Status Style
        printerStatusLabel.text = receivedPrinter?.printerStatus == 0 ? "Available" : "UnAvailable"
        // calc Price
        let price = receivedPrintouts.map { $0.price }.reduce(0.0, { a, b in
            a + b
        })
        totalPriceLabel.text = Formater.formatAsUSD(amount: price)
        if receivedPrinter?.printerStatus == 0 {
            printerStatusLabel.textColor = UIColor(named: "sencondary600")
        } else {
            printerStatusLabel.textColor = UIColor(named: "alert")
            confirmButton.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
            confirmButton.isEnabled = false
        }
    }
    
    private func setUpUI() {
        StyleHelper.commonLayer(layer: dialogView.layer)
        confirmButton.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderColor = UIColor.black.cgColor
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
