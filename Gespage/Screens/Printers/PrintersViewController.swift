//
//  PrintersViewController.swift
//  Gespage
//
//  Created by Duy Pham on 03/08/2023.
//

import UIKit
import RxCocoa
import RxSwift

protocol PrintersViewControllerDelegate: AnyObject {
    func onRequestReset()
}

class PrintersViewController: UIViewController, UISearchBarDelegate {
    weak var delegate: PrintersViewControllerDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    
    // init state
    var printerId: String?
    var isDialogConfirm = false
    // received Data
    var receivedTitle: String?
    var receivedPrintouts: [PrintoutModelResponse] = []
    let disposed = DisposeBag()
    var dataPrinters: [PrinterModel] = []
    var filterDataPrinters: BehaviorRelay<[PrinterModel]> = BehaviorRelay(value: [])
}

// MARK: Life Cycle
extension PrintersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titlePage.text = receivedTitle
        
        // Hide Header Default
        navigationController?.navigationBar.isHidden = true
        
        setUpTableView()
        setUpSearchBar()
        
        checkPermissionSignIn()
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
            self.onGetPrinters(isFetching: false)
            // Stop the refresh control
            self.refreshControl.endRefreshing()
            let topIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "PrinterTableViewCell")
        tableView.register(UINib(nibName: "EmptyPrinterTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyPrinterTableViewCell")
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.filterPrinters(query)
                self?.tableView.reloadData()
            }).disposed(by: disposed)
    }
    
    private func filterPrinters(_ query: String) {
        var filtered: [PrinterModel] = []
        if query.isEmpty {
            filtered = dataPrinters
        } else {
            filtered = dataPrinters.filter{
                $0.printerId.localizedStandardContains(query) ||
                $0.printerName.localizedStandardContains(query)
            }
        }
        filterDataPrinters.accept(filtered)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - APIs
extension PrintersViewController {
    private func checkPermissionSignIn() {
        UserCredentialState.shared.userCredential
            .subscribe(onNext: { [weak self] user in
                if user != nil {
                    self?.onGetPrinters()
                } else {
                    self?.dataPrinters = []
                }
                self?.tableView?.reloadData()
            })
            .disposed(by: disposed)
    }
    
    private func onGetPrinters(isFetching: Bool = true) {
        if isFetching {
            ManagerAlert.shared.showLoading(in: self)
        }
        APIManager.shared.performRequest(
            for: "/mobileprint/printers",
            method: .GET,
            responseType: [PrinterModel].self
        ).subscribe(onNext: { [self] result in
            switch result {
            case .success(let response):
                let data = response.sorted {(a, b) -> Bool in return a.printerStatus < b.printerStatus }
                
                self.dataPrinters = data
                self.filterDataPrinters.accept(data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                APIManager.shared.logError(error: error)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ManagerAlert.shared.dismissLoading()
            }
        }).disposed(by: disposed)
    }
    
    private func onReleaseDocs() {
        let printoutIds = receivedPrintouts.map { $0.printoutId }
        ManagerAlert.shared.showLoading(in: self, message: "Release Documents...")
        APIManager.shared.performRequest(
            for: "/mobileprint/release/\(printerId!)",
            method: .POST,
            requestModel: PrintoutIdsModel(printouts: printoutIds),
            responseType: String.self
        ).subscribe(onNext: { [self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    ManagerAlert.shared.dismissLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showDialog(
                        title: "Releasing document(s)",
                        message: "Your documents have been released successfully.",
                        status: "success"
                    )
                }
                
                break
            case .failure(let error):
                self.showDialog(
                    title: "Document release error",
                    message: "Your document could not be released.",
                    status: "error"
                )
                APIManager.shared.logError(error: error)
            }
            
        }
        ).disposed(by: disposed)
    }
    
    private func showDialog(
        title: String,
        message: String,
        status: String
    ) {
        DialogManager.shared.showCommonDialog(
            from: self,
            title: title,
            message: "Your documents have been released successfully.",
            labelButton: "Go To Release List", statusImage: UIImage(named: status)!,
            onConfirm: { [self] in
                dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if status == "success" {
                        let printoutIds = self.receivedPrintouts.map { $0.printoutId }
                        self.delegate?.onRequestReset()
                        self.navigationController?.popToRootViewController(animated: true)
                        PrintoutState.shared.removePrintoutModelResponse(printoutIds)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        )
    }
}

// MARK: - Table View Printers
extension PrintersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterDataPrinters.value.isEmpty {
            return 1
        } else {
            return filterDataPrinters.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filterDataPrinters.value.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyPrinterTableViewCell", for: indexPath) as! EmptyPrinterTableViewCell
            cell.backgroundColor = .clear
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterTableViewCell", for: indexPath) as! PrinterTableViewCell
            cell.bind(printerModel: dataPrinters[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isDialogConfirm = true
        let printer = filterDataPrinters.value[indexPath.row]
        printerId = printer.printerId
        if !receivedPrintouts.isEmpty {
            DialogManager.shared.showConfirmReleaseDialog(
                from: self,
                printouts: receivedPrintouts,
                printer: printer,
                onConfirm: {[self] in
                    self.dismiss(animated: true, completion: nil)
                    isDialogConfirm = false
                    self.onReleaseDocs()
                }
            )
        }
    }
}

// MARK: - @IBOutlet
extension PrintersViewController {
    @IBAction func backButtonAction(_ sender: UIButton) {
        isDialogConfirm = false
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - DialogPresentationController
extension PrintersViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: isDialogConfirm ? 466 : 276, isDialog: true)
    }
}
