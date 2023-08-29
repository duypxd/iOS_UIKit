//
//  HomePrinterFavoritesTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 02/08/2023.
//

import UIKit
import RxCocoa
import RxSwift

protocol HomePrinterFavoritesDelegate: AnyObject {
    func onViewAllPrintersTapped()
}

class HomePrinterFavoritesTableViewCell: UITableViewCell {
    weak var delegate: HomePrinterFavoritesDelegate?
    
    @IBOutlet weak var onViewAllPrintersAction: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let disposed = DisposeBag()
    var dataPrinters: [PrinterModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkPermissionSignIn()
        backgroundColor = .clear
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

// MARK: - Call APIs
extension HomePrinterFavoritesTableViewCell {
    private func checkPermissionSignIn() {
        UserCredentialState.shared.userCredential
            .subscribe(onNext: { [weak self] user in
                if user != nil {
                    self?.onGetPrinters()
                } else {
                    self?.dataPrinters = []
                }
                self?.onViewAllPrintersAction.isHidden = user == nil
                self?.tableView?.reloadData()
            })
            .disposed(by: disposed)
    }
    
    private func onGetPrinters() {
        APIManager.shared.performRequest(
            for: "/mobileprint/printers",
            method: .GET,
            responseType: [PrinterModel].self
        ).subscribe(onNext: { [self] result in
            switch result {
            case .success(let response):
                let data = response.sorted {(a, b) -> Bool in return a.printerStatus < b.printerStatus }
                
                self.dataPrinters = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                APIManager.shared.handlerError(error: error)
            }
        }).disposed(by: disposed)
    }
}

// MARK: - Life Cycle Table View
extension HomePrinterFavoritesTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataPrinters.isEmpty {
            return 1
        }
        return dataPrinters.suffix(3).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataPrinters.suffix(3).isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyPrinterTableViewCell", for: indexPath) as! EmptyPrinterTableViewCell
            cell.backgroundColor = .clear
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterTableViewCell", for: indexPath) as! PrinterTableViewCell
            cell.bind(printerModel: dataPrinters[indexPath.row])
            return cell
        }
    }
}
