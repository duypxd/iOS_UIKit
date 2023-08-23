//
//  BottomSheetViewController.swift
//  Gespage
//
//  Created by Duy Pham on 15/08/2023.
//

import UIKit

class AppBottomSheetViewController: UIViewController {

    @IBOutlet weak var bottomSheetHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iOSView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var receivedData: [String] = []
    var bottomSheetHeight: CGFloat = 0
    var bottomSheetTitle: String?
    var selectedItem: String?
    var didSelectRow: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AppLabelSelectorTableViewCell", bundle: nil), forCellReuseIdentifier: "AppLabelSelectorTableViewCell")
        // setup layout in bottomsheet
        titleLabel.text = bottomSheetTitle
        iOSView.layer.cornerRadius = 3
        StyleHelper.applyCornerRadius(layer: bottomSheetView.layer, corners: [.topLeft, .topRight], radius: 12)
        
        // Setup height bottomsheet
        bottomSheetHeightConstraint.constant = bottomSheetHeight
    }
    
}

// MARK: - Init Table View
extension AppBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppLabelSelectorTableViewCell", for: indexPath) as! AppLabelSelectorTableViewCell
        let currentItem = receivedData[indexPath.row]
        
        let isSelected = selectedItem == currentItem
        
        cell.appSelectorLabel.text = receivedData[indexPath.row]
        cell.appChecedImage.isHidden = !isSelected
        if isSelected {
            cell.appSelectorView.backgroundColor = UIColor(named: "infoSoft")
            StyleHelper.commonLayer(layer: cell.appSelectorView.layer)
        }
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
}

class AppBottomSheetManager {
    static func presentBottomSheet(
        from viewController: UIViewController,
        receivedData: [String],
        title: String,
        selectedItem: String?,
        heightBottomSheet: CGFloat = 220,
        enableScroll: Bool = false,
        didSelectRow: ((Int) -> Void)?
    ) {
        let storyboard = UIStoryboard(name: "AppBottomSheetStoryboard", bundle: nil)
        
        if let sheetVC = storyboard.instantiateViewController(withIdentifier: "AppBottomSheetViewController") as? AppBottomSheetViewController {
            sheetVC.modalPresentationStyle = .custom
            sheetVC.bottomSheetHeight = heightBottomSheet
            sheetVC.receivedData = receivedData
            sheetVC.bottomSheetTitle = title
            sheetVC.selectedItem = selectedItem
            sheetVC.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
            sheetVC.didSelectRow = didSelectRow
            
            viewController.view.endEditing(true)
            
            viewController.present(sheetVC, animated: true, completion: nil)
            
            if enableScroll {
                sheetVC.tableView.isScrollEnabled = true
                sheetVC.tableView.alwaysBounceVertical = true
            }
            
            DispatchQueue.main.async {
                sheetVC.bottomSheetHeight = heightBottomSheet
                sheetVC.bottomSheetView.frame.size.height = heightBottomSheet
                sheetVC.view.layoutIfNeeded()
            }
        }
    }
}

