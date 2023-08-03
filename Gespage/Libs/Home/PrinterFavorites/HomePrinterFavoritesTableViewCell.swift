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
        
        tableView.register(UINib(nibName: "PrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "PrinterTableViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onViewAllPrintersAction(_ sender: UIButton) {
        delegate?.onViewAllPrintersTapped()
    }
    
}

extension HomePrinterFavoritesTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MockData.dataPrinters.suffix(3).count
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
