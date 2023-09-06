//
//  PrintOptionViewController.swift
//  Gespage
//
//  Created by Duy Pham on 10/08/2023.
//

import UIKit
import RxCocoa
import RxSwift

class PrintOptionViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPrint: UIButton!
    
    var isDialogSuccess = false
    var dataPaperSize: [String] = []
    var printoutModelRequest: PrintoutModelRequest?
    var receivedPaths: [String] = []
    
    let disposed = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init data
        dataPaperSize = ["A1", "A2", "A3", "A4", "A5", "A6"]
        printoutModelRequest = PrintoutModelRequest(
            copies: 0,
            color: true,
            format: dataPaperSize.first ?? "",
            duplex: true,
            files: receivedPaths,
            selectedPages: nil,
            landscape: true
        )
        // setup UI
        buttonPrint.layer.cornerRadius = 12
        buttonPrint.clipsToBounds = true
        // setup tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // register cells
        let cellIdentifiers = [
            "SelectorTableViewCell",
            "SelectorAndInputTableViewCell"
        ]
        
        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
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

// MARK: - @IBActions
extension PrintOptionViewController {
    
    @IBAction func buttonBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPrintAction(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? SelectorAndInputTableViewCell {
            if isValidNumberOfCopies(cell) {
                ManagerAlert.shared.showLoading(in: self)
                
                let formData = MultipartFormData()
                formData.append(String(printoutModelRequest?.copies ?? 1), withName: "copies")
                formData.append(String(printoutModelRequest?.color ?? true), withName: "color")
                formData.append(printoutModelRequest?.format ?? "", withName: "format")
                formData.append(String(printoutModelRequest?.duplex ?? true), withName: "duplex")
                formData.append(String(printoutModelRequest?.landscape ?? true), withName: "landscape")

                for filePath in (printoutModelRequest?.files ?? []) {
                    if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
                        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
                        let mimeType = "application/octet-stream"
                        formData.append(fileData, withName: "files[]", fileName: fileName, mimeType: mimeType)
                    }
                }

                if let selectedPages = printoutModelRequest?.selectedPages {
                    formData.append(selectedPages, withName: "selectedPages")
                }

                formData.append("\(String(describing: printoutModelRequest?.landscape))", withName: "landscape")
                
                APIManager.shared.performRequest(
                    for: "/mobileprint/printouts",
                    method: .POST,
                    formData: formData,
                    responseType: [PrintoutModelResponse].self
                ).subscribe { [self] result in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        ManagerAlert.shared.dismissLoading()
                    }
                    switch result {
                    case .success(let printouts):
                        PrintoutState.shared.addPrintoutModelResponse(printouts)
                        showAlertSuccess()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.showAlertSuccess()
                        }
                    case .failure(let error):
                        APIManager.shared.logError(error: error)
                    }
                }.disposed(by: disposed)
            }
        }
    }
    
    private func showAlertSuccess() {
        isDialogSuccess = true
        DialogManager.shared.showCommonDialog(
            from: self,
            title: "Added successfully!",
            message: "Successfully added to Ready to Release list. Go there to release your document(s)",
            labelButton: "Go To Release List", statusImage: UIImage(named: "success")!,
            onConfirm: { [self] in
                isDialogSuccess = false
                dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        )
    }
}

// MARK: - Validation TextFields
extension PrintOptionViewController {
    private func isValidNumberOfCopies(_ cell: SelectorAndInputTableViewCell) -> Bool {
        if let numberOfCopiesText = cell.numberOfCopies.text,
           let numberOfCopies = Int(numberOfCopiesText), numberOfCopies > 0 {
            cell.errorMessageLabel.isHidden = true
            return true
        } else {
            cell.errorMessageLabel.text = "Invalid number of copies"
            cell.errorMessageLabel.isHidden = false
            return false
        }
    }
}


// MARK: - Table View
extension PrintOptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectorAndInputTableViewCell", for: indexPath) as! SelectorAndInputTableViewCell
            cell.tapAction = {[weak self] in
                if indexPath.row == 0 {
                    self?.onChangedPaperSize()
                }
            }
            cell.onChangedNumberOfCopies = {[self] value in
                if let newValue = Int(value) {
                    printoutModelRequest?.copies = newValue
                } else {
                    printoutModelRequest?.copies = 0
                }
                if isValidNumberOfCopies(cell) {}
            }
            cell.paperSizeLabel.text = printoutModelRequest?.format ?? ""
            
            return cell
        case 1...3:
            let selectorCell = tableView.dequeueReusableCell(withIdentifier: "SelectorTableViewCell", for: indexPath) as! SelectorTableViewCell
            selectorCell.tapAction = { [weak self] in
                switch indexPath.row {
                case 1:
                    self?.onChangedOrientation()
                case 2:
                    self?.onChangedColor()
                case 3:
                    self?.onChangedTwoSide()
                default:
                    break
                }
            }
                        
            selectorCell.bind(indexPath: indexPath, printoutModelRequest: printoutModelRequest)
            return selectorCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Implement Actions in TableView
extension PrintOptionViewController: UIViewControllerTransitioningDelegate {
    private func onChangedPaperSize() {
        AppBottomSheetManager.presentBottomSheet(
            from: self,
            receivedData: dataPaperSize,
            title: "Select Paper size",
            selectedItem: printoutModelRequest?.format,
            heightBottomSheet: 400,
            enableScroll: true,
            didSelectRow: { [self] selectedIndex in
                printoutModelRequest?.format = dataPaperSize[selectedIndex]
                tableView.reloadData()
            }
        )
    }
    
    private func onChangedOrientation() {
        let data = MockDataPrintout.dataLandscape
        AppBottomSheetManager.presentBottomSheet(
            from: self,
            receivedData: data,
            title: "Select orientation",
            selectedItem: printoutModelRequest?.landscape == true ? data.last : data.first,
            didSelectRow: { [self] selectedIndex in
                printoutModelRequest?.landscape = data[selectedIndex] == data.last
                tableView.reloadData()
            }
        )
    }
    
    private func onChangedColor() {
        let data = MockDataPrintout.dataColors
        AppBottomSheetManager.presentBottomSheet(
            from: self,
            receivedData: data,
            title: "Select color",
            selectedItem: printoutModelRequest?.color == true ? data.first : data.last,
            didSelectRow: { [self] selectedIndex in
                printoutModelRequest?.color = data[selectedIndex] == data.first
                tableView.reloadData()
            }
        )
    }
    
    private func onChangedTwoSide() {
        let data = MockDataPrintout.dataTwoSide
        AppBottomSheetManager.presentBottomSheet(
            from: self,
            receivedData: data,
            title: "Select Two-side",
            selectedItem: printoutModelRequest?.duplex == true ? data.first : data.last,
            didSelectRow: { [self] selectedIndex in
                printoutModelRequest?.duplex = data[selectedIndex] == data.first
                tableView.reloadData()
            }
        )
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if isDialogSuccess {
            return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: 276, isDialog: true)
        } else {
            return CommonPresentationController(
                presentedViewController: presented,
                presenting: presenting,
                height: (presented as? AppBottomSheetViewController)?.bottomSheetHeight,
                isDialog: false
            )
        }
    }
}
