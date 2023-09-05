//
//  PrintViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit
import RxCocoa
import RxSwift

class PrintViewController: UIViewController, PrintersViewControllerDelegate {
    @IBOutlet weak var buttonRelease: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDocLabel: UILabel!
    @IBOutlet weak var selectedDocsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var buttonSelectAll: UIButton!
    @IBOutlet weak var buttonAddDocs: UIButton!
    
    private var refreshControl = UIRefreshControl()
    
    var pickerImageHelper: PickerImageHelper!
    var fileSystemHelper: FileSystemHelper!
    
    var dataPrintouts: [PrintoutModelResponse] = []
    var selectedPrintouts: [PrintoutModelResponse] = []
    
    let disposed = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissionSignIn()
        checkPrintoutResponse()
        
        pickerImageHelper = PickerImageHelper(viewController: self)
        fileSystemHelper = FileSystemHelper(viewController: self)
        
        // Hide UI
        viewButtons.isHidden = true
        setUpUIButton()
        setUpTableView()
    }
    
    private func setUpUIButton() {
        buttonRelease.layer.cornerRadius = 12
        buttonDelete.layer.borderWidth = 1
        buttonDelete.layer.cornerRadius = 12
        buttonDelete.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PrintoutTableViewCell", bundle: nil), forCellReuseIdentifier: "PrintoutTableViewCell")
        tableView.register(UINib(nibName: "EmptyPrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyPrinterTableViewCell")
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func onRequestReset() {
        self.reset()
        // self.refreshData()
    }
}

// MARK: - APIs
extension PrintViewController {
    private func checkPermissionSignIn() {
        UserCredentialState.shared.userCredential
            .subscribe(onNext: { [weak self] user in
                if user != nil {
                    self?.onGetPrintous()
                } else {
                    self?.dataPrintouts = []
                    self?.reset()
                }
                self?.tableView?.reloadData()
            })
            .disposed(by: disposed)
    }
    
    private func onGetPrintous(isFetching: Bool = true) {
        if isFetching {
            ManagerAlert.showLoading(in: self)
        }
        APIManager.shared.performRequest(
            for: "/mobileprint/printouts",
            method: .GET,
            responseType: [PrintoutModelResponse].self
        ).subscribe(onNext: { [self] result in
            switch result {
            case .success(let printouts):
                self.dataPrintouts = printouts
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                APIManager.shared.logError(error: error)
            }
            DispatchQueue.main.async {
                ManagerAlert.dismissLoading(in: self)
            }
        }).disposed(by: disposed)
    }
    
    private func onDeleteDocument() {
        let printoutIds = selectedPrintouts.map { $0.printoutId }
        ManagerAlert.showLoading(in: self, message: "Delete Document(s)...")
        // Delete Printout From Local
        dataPrintouts = dataPrintouts.filter { item in
            !printoutIds.contains { printoutId in
                return printoutId == item.printoutId
            }
        }
        tableView.reloadData()
        reset()
        // Call API to Deleted
        APIManager.shared.performRequest(
            for: "/mobileprint/printouts",
            method: .DELETE,
            requestModel: PrintoutIdsModel(printouts: printoutIds),
            responseType: String.self
        ).subscribe(onNext: { [self] result in
            DispatchQueue.main.async {
                ManagerAlert.dismissLoading(in: self)
            }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                APIManager.shared.showError(in: self, error: error)
            }

        }
        ).disposed(by: disposed)
    }
    
    private func checkPrintoutResponse() {
        PrintoutState.shared.printoutModelResponse.subscribe(
            onNext: { [weak self] printouts in
                print("printouts-------> \(printouts)")
                if printouts?.count ?? 0 > 0 {
                    self?.onGetPrintous(isFetching: false)
                }
            }
        ).disposed(by: disposed)
    }
    
    private func reset() {
        buttonSelectAll.isHidden = true
        selectedDocsLabel.isHidden = true
        totalPriceLabel.isHidden = true
        viewButtons.isHidden = true
        selectedPrintouts = []
        setSelectAllStyle("Select All", "greyG100")
    }
}

// MARK: - UITableView
extension PrintViewController: UITableViewDataSource, UITableViewDelegate {
    @objc private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.onGetPrintous(isFetching: false)
            self.refreshControl.endRefreshing()
            let topIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataPrintouts.isEmpty {
            return 1
        } else {
            return dataPrintouts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataPrintouts.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyPrinterTableViewCell", for: indexPath) as! EmptyPrinterTableViewCell
            cell.backgroundColor = .clear
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrintoutTableViewCell", for: indexPath) as! PrintoutTableViewCell
            // Init Hide UI
            selectedDocsLabel.isHidden = true
            totalPriceLabel.isHidden = true
            
            let printoutModel = dataPrintouts[indexPath.row]
            let selectedIDs = selectedPrintouts.map { $0.printoutId }
            
            cell.bind(printoutModel, selectedIDs)
            
            if !dataPrintouts.isEmpty {
                buttonSelectAll.isHidden = false
            }
            
            // Check SelectedIds > 0
            if selectedIDs.count > 0 {
                selectedDocsLabel.isHidden = false
                totalPriceLabel.isHidden = false
                sumTotalPrintout()
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !dataPrintouts.isEmpty {
            let printoutModel = dataPrintouts[indexPath.row]
            onSelectPrintout(printoutModel)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


// MARK: - @IBActions
extension PrintViewController {
    @IBAction func buttonAddDocAction(_ sender: UIButton) {
        let imageOption = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.pickerImageHelper.pickImage { imageURL in
                if let imageURL = imageURL {
                    self.navigateToPreview([imageURL])
                }
            }
        }
        let fileOption = UIAlertAction(title: "File System", style: .default) { _ in
            self.fileSystemHelper.pickFiles { selectedURLs in
                if !selectedURLs.isEmpty {
                    self.navigateToPreview(selectedURLs)
                }
            }
        }
        ActionSheetHelper.showActionSheet(with: [imageOption, fileOption],message: "Add Documents", from: self)
    }
    
    @IBAction func printoutButtonAction(_ sender: UIButton) {
        selectAllPrintout()
        setUIPrintoutEmpty()
        tableView.reloadData()
    }
    
    @IBAction func buttonReleaseAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "PrintersStoryboard", bundle: nil)
        if let printersVC = storyboard.instantiateViewController(withIdentifier: "PrintersViewController") as? PrintersViewController {
            navigationController?.pushViewController(printersVC, animated: true)
            printersVC.delegate = self
            printersVC.receivedTitle = "Select Printer"
            printersVC.receivedPrintouts = selectedPrintouts
        }
    }
    
    @IBAction func buttonDeleteAction(_ sender: UIButton) {
        DialogManager.shared.showConfirmDialog(
            from: self,
            title: "Delete Document(s)",
            message: "Do you want to delete the selected Documents?",
            labelConfirm: "Delete",
            backgroundColorConfirm: UIColor(named: "error")!,
            onConfirm: {
                self.dismiss(animated: true, completion: nil)
                self.onDeleteDocument()
            }
        )
    }
    
    private func navigateToPreview(_ paths: [URL]) {
        let storyboard = UIStoryboard(name: "PreviewFileStoryboard", bundle: nil)
        if let previewFileVC = storyboard.instantiateViewController(withIdentifier: "PreviewFileViewController") as? PreviewFileViewController {
            previewFileVC.receivedPaths = paths
            self.navigationController?.pushViewController(previewFileVC, animated: true)
        }
    }
}

// MARK: - Printout Actions
extension PrintViewController {
    private func onSelectPrintout(_ printoutModel: PrintoutModelResponse) {
        let selectedIDs: [Int] = selectedPrintouts.map{$0.printoutId}
        if selectedIDs.contains(printoutModel.printoutId) {
            if let index = selectedIDs.firstIndex(of: printoutModel.printoutId) {
                selectedPrintouts.remove(at: index)
            }
        } else {
            selectedPrintouts.append(printoutModel)
        }
        
        if selectedPrintouts.count == dataPrintouts.count {
            setSelectAllStyle("Deselect All", "error")
        } else {
            setSelectAllStyle("Select All", "greyG100")
        }
        
        setUIPrintoutEmpty()
    }
    
    private func sumTotalPrintout() {
        let amount = selectedPrintouts.map { $0.price ?? 0 }.reduce(0, +)
        let formatPrice = Formater.formatAsUSD(amount: amount)
        totalPriceLabel.text = "Total: \(formatPrice ?? "0")"
        selectedDocsLabel.text = "Selected Document (\(selectedPrintouts.count))"
    }
    
    private func selectAllPrintout() {
        if selectedPrintouts.count != dataPrintouts.count {
            selectedPrintouts = dataPrintouts
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

// MARK: - DialogPresentationController
extension PrintViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: 180, isDialog: true)
    }
}
