//
//  HomePrinterFavoritesTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 02/08/2023.
//

import UIKit

class HomePrinterFavoritesTableViewCell: UITableViewCell {
    var dataPrinters: [PrinterModel] = [
        PrinterModel(printerId: "XTX123456", name: "RICOH MP C301", status: "Available"),
        PrinterModel(printerId: "XTX123123", name: "RICOH MP C302", status: "Unavailable"),
        PrinterModel(printerId: "XTX123ABC", name: "RICOH MP C303", status: "Unavailable")
    ]

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
    
}

extension HomePrinterFavoritesTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPrinters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterTableViewCell", for: indexPath) as! PrinterTableViewCell
        
        cell.printerId.text = dataPrinters[indexPath.row].printerId
        cell.printerName.text = dataPrinters[indexPath.row].name
        cell.printerStatus.text = dataPrinters[indexPath.row].status
        
        if dataPrinters[indexPath.row].status == "Available" {
            cell.printerStatus.textColor = UIColor(named: "sencondary600")
        }
        
        return cell
    }
}
