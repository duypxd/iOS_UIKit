//
//  HomePrinterFavoritesTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 02/08/2023.
//

import UIKit

protocol HomePrinterFavoritesDelegate: AnyObject {
    func onViewAllPrintersTapped()
}

class HomePrinterFavoritesTableViewCell: UITableViewCell {
    weak var delegate: HomePrinterFavoritesDelegate?
    
    @IBOutlet weak var onViewAllPrintersAction: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // register cells
        tableView.register(UINib(nibName: "PrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "PrinterTableViewCell")
        tableView.register(UINib(nibName: "EmptyPrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyPrinterTableViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onViewAllPrintersAction(_ sender: UIButton) {
        delegate?.onViewAllPrintersTapped()
    }
    
}

// MARK: - Life Cycle Table View
extension HomePrinterFavoritesTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MockData.dataPrinters.isEmpty {
            return 1
        }
        return MockData.dataPrinters.suffix(3).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if MockData.dataPrinters.suffix(3).isEmpty {
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
}
