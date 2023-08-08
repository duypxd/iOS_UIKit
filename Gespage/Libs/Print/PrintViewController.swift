//
//  PrintViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit

class PrintViewController: UIViewController {
    @IBOutlet weak var buttonRelease: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDocLabel: UILabel!
    @IBOutlet weak var selectedDocsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var buttonSelectAll: UIButton!
    
    var selectedPrintouts: [PrintoutModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide UI
        viewButtons.isHidden = true
        // Custom UI
        buttonRelease.layer.cornerRadius = 12
        buttonDelete.layer.borderWidth = 1
        buttonDelete.layer.cornerRadius = 12
        buttonDelete.layer.borderColor = UIColor.black.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        // Register Cells
        tableView.register(UINib(nibName: "PrintoutTableViewCell", bundle: nil), forCellReuseIdentifier: "PrintoutTableViewCell")
    }
}

// MARK: - UITableView
extension PrintViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MockData.dataPrintouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrintoutTableViewCell", for: indexPath) as! PrintoutTableViewCell
        // Init Hide UI
        cell.printoutCheckbox.isHidden = true
        selectedDocsLabel.isHidden = true
        totalPriceLabel.isHidden = true
        
        cell.backgroundColor = .clear
        
        let printoutModel = MockData.dataPrintouts[indexPath.row];
        
        cell.printoutName.text = printoutModel.fileName
        cell.printoutColor.text = String(printoutModel.colorPages)
        cell.printoutBlackWhite.text = String(printoutModel.bwPages)
        cell.prinoutPrice.text = Formater.formatAsUSD(amount: printoutModel.price)
        cell.printoutDate.text = DateFormat.formatYYYYMMDD(printoutModel.date,outputFormat: "yyyy/MM/dd HH:mm")
        cell.printoutStatus.text = printoutModel.status
        
        // Prinout Status
        printoutStatus(printoutModel.status, cell)
        
        // Check Selected Printout
        let selectedIDs = selectedPrintouts.map { $0.printoutId }
        if selectedIDs.contains(printoutModel.printoutId) {
            cell.printoutImage.image = UIImage(named: "printoutActive")
            cell.printoutCheckbox.isHidden = false
        } else {
            cell.printoutImage.image = UIImage(named: "printoutInActive")
        }
        
        // Check SelectedIds > 0
        if selectedIDs.count > 0 {
            selectedDocsLabel.isHidden = false
            totalPriceLabel.isHidden = false
            sumTotalPrintout()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let printoutModel = MockData.dataPrintouts[indexPath.row]
        onSelectPrintout(printoutModel)
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }

}

// MARK: - @IBActions
extension PrintViewController {
    @IBAction func printoutButtonAction(_ sender: UIButton) {
        selectAllPrintout()
        setUIPrintoutEmpty()
        tableView.reloadData()
    }
    
    @IBAction func buttonReleaseAction(_ sender: UIButton) {
        print("release")
    }
    
    @IBAction func buttonDeleteAction(_ sender: UIButton) {
        let dialogVC = UIStoryboard(name: "DialogConfirmStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DialogConfirmViewController") as! DialogConfirmViewController
        
        dialogVC.showDialog(
            titleValue: "Delete Document(s)",
            contentValue: "Do you want to delete the selected Documents?",
            buttonLabel: "Delete",
            buttonBackgroundColor: UIColor(named: "error")!,
            confirmAction: { [weak self] in
                self?.onConfirmDeleteDoc()
            }
        )
        
        dialogVC.modalPresentationStyle = .custom
        dialogVC.transitioningDelegate = self
        present(dialogVC, animated: true, completion: nil)
    }
    
    private func onConfirmDeleteDoc() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - DialogPresentationController
extension PrintViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: 180, isDialog: true)
        }
}

// MARK: - Printout Actions
extension PrintViewController {
    
    private func printoutStatus(_ status: String, _ cell:  PrintoutTableViewCell) {
        // Status Printing
        switch status {
        case "pending":
            cell.printoutDotView.isHidden = false
            cell.printoutStatus.isHidden = false
            cell.printoutStatus.textColor = UIColor(named: "alert")
            break
        case "completed":
            cell.printoutDotView.isHidden = true
            cell.printoutStatus.isHidden = true
            break
        case"printing":
            cell.printoutDotView.isHidden = false
            cell.printoutStatus.isHidden = false
            cell.printoutStatus.textColor = UIColor(named: "primary600")
            break
        case "error":
            cell.printoutDotView.isHidden = false
            cell.printoutStatus.isHidden = false
            cell.printoutStatus.textColor = UIColor(named: "error")
            break
        default:
            break
        }
    }
    
    private func onSelectPrintout(_ printoutModel: PrintoutModel) {
        let selectedIDs: [Int] = selectedPrintouts.map{$0.printoutId}
        if selectedIDs.contains(printoutModel.printoutId) {
            if let index = selectedIDs.firstIndex(of: printoutModel.printoutId) {
                selectedPrintouts.remove(at: index)
            }
        } else {
            selectedPrintouts.append(printoutModel)
            
        }
        
        if selectedPrintouts.count == MockData.dataPrintouts.count {
            setSelectAllStyle("Deselect All", "error")
        } else {
            setSelectAllStyle("Select All", "greyG100")
        }
        
        setUIPrintoutEmpty()
    }
    
    private func sumTotalPrintout() {
        let amount = selectedPrintouts.map { $0.price }.reduce(0, +)
        let formatPrice = Formater.formatAsUSD(amount: amount)
        totalPriceLabel.text = "Total: \(formatPrice ?? "0")"
        selectedDocsLabel.text = "Selected Document (\(selectedPrintouts.count))"
    }
    
    private func selectAllPrintout() {
        if selectedPrintouts.count != MockData.dataPrintouts.count {
            selectedPrintouts = MockData.dataPrintouts
            setSelectAllStyle("Deselect All", "error")
        } else {
            setSelectAllStyle("Select All", "greyG100")
            selectedPrintouts = []
        }
    }
    
    private func setUIPrintoutEmpty() {
        var bottom: CGFloat = 0
        if selectedPrintouts.isEmpty {
            viewButtons.isHidden = true
            bottom = 0
        } else {
            bottom = 72
            viewButtons.isHidden = false
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
    }
    
    private func setSelectAllStyle(_ labelName: String, _ colorName: String) {
        buttonSelectAll.setTitle(labelName, for: .normal)
        buttonSelectAll.setTitleColor(UIColor(named: colorName), for: .normal)
        buttonSelectAll.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
}
