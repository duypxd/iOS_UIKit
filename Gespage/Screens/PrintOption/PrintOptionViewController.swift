//
//  PrintOptionViewController.swift
//  Gespage
//
//  Created by Duy Pham on 10/08/2023.
//

import UIKit

class PrintOptionViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPrint: UIButton!
    
    var dataPaperSize: [String] = []
    var printoutModelRequest: PrintoutModelRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init data
        dataPaperSize = ["A1", "A2", "A3", "A4", "A5", "A6"]
        printoutModelRequest = PrintoutModelRequest(
            copies: "",
            color: "Color",
            format: dataPaperSize.first ?? "",
            duplex: "Yes",
            files: [],
            selectedPages: nil,
            landscape: "Portrait"
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
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "SelectorAndInputTableViewCell", for: indexPath) as! SelectorAndInputTableViewCell
            firstCell.tapAction = {[weak self] in
                if indexPath.row == 0 {
                    self?.onChangedPaperSize()
                }
            }
            firstCell.onChangedNumberOfCopies = {[self] value in
                printoutModelRequest?.copies = value
            }
            firstCell.paperSizeLabel.text = printoutModelRequest?.format ?? ""
            
            return firstCell
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
                        
            switch indexPath.row {
            case 1:
                selectorCell.titleLabel?.text = "Orientation"
                selectorCell.selectorLabel.text = printoutModelRequest?.landscape
            case 2:
                selectorCell.titleLabel?.text = "Color"
                selectorCell.selectorLabel.text = printoutModelRequest?.color
            case 3:
                selectorCell.titleLabel?.text = "Two-side"
                selectorCell.selectorLabel.text = printoutModelRequest?.duplex
            default:
                break
            }
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
        let dataLandscape = ["Portrait", "Landscape"]
        AppBottomSheetManager.presentBottomSheet(
            from: self,
            receivedData: dataLandscape,
            title: "Select orientation",
            selectedItem: printoutModelRequest?.landscape,
            didSelectRow: { [self] selectedIndex in
                printoutModelRequest?.landscape = dataLandscape[selectedIndex]
                tableView.reloadData()
            }
        )
    }
    
    private func onChangedColor() {
        let dataColors = ["Color", "Black and white"]
        AppBottomSheetManager.presentBottomSheet(
            from: self,
            receivedData: dataColors,
            title: "Select color",
            selectedItem: printoutModelRequest?.color,
            didSelectRow: { [self] selectedIndex in
                printoutModelRequest?.color = dataColors[selectedIndex]
                tableView.reloadData()
            }
        )
    }
    
    private func onChangedTwoSide() {
        let dataTwoSide = ["Yes", "No"]
        AppBottomSheetManager.presentBottomSheet(
            from: self,
            receivedData: dataTwoSide,
            title: "Select Two-side",
            selectedItem: printoutModelRequest?.duplex,
            didSelectRow: { [self] selectedIndex in
                printoutModelRequest?.duplex = dataTwoSide[selectedIndex]
                tableView.reloadData()
            }
        )
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CommonPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            height: (presented as? AppBottomSheetViewController)?.bottomSheetHeight,
            isDialog: false
        )
    }
}
