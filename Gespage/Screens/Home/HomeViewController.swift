//
//  HomeViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    enum TableViewCellIdentifier: String {
        case balance = "BalanceTableViewCell"
        case signInBanner = "SignInBannerTableViewCell"
        case homeEcological = "HomeTableViewCellEcologicalCell"
        case homeDistribution = "HomeDistributionTableViewCell"
        case homePrinterFavorites = "HomePrinterFavoritesTableViewCell"
    }
    
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    var userCredential: UserCredentialModel?
    
    var cellIdentifiers = [
        TableViewCellIdentifier.balance.rawValue,
        TableViewCellIdentifier.homeEcological.rawValue,
        TableViewCellIdentifier.homeDistribution.rawValue,
        TableViewCellIdentifier.homePrinterFavorites.rawValue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserCredentialState.shared.userCredential
            .subscribe(onNext: { [weak self] user in
                self?.userCredential = user
                if user != nil {
                    if let indexToRemove = self?.cellIdentifiers.firstIndex(of: TableViewCellIdentifier.signInBanner.rawValue) {
                        self?.cellIdentifiers.remove(at: indexToRemove)
                    }
                } else {
                    self?.cellIdentifiers.insert(TableViewCellIdentifier.signInBanner.rawValue, at: 1)
                }
                self?.tableView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        tableView.delegate = self
        tableView.dataSource = self
        // HomeTableViewCellEcologicalCell
        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }
}

// MARK: - Table View Cell
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = cellIdentifiers[indexPath.row]
        
        switch TableViewCellIdentifier(rawValue: cellIndentifier) {
        case .balance:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as! BalanceTableViewCell
                cell.backgroundColor = .clear
                cell.username.text = userCredential?.fullName ?? "Gespage User"
                cell.balance.text = Formater.formatAsUSD(amount: userCredential?.userCredit ?? 0.0)
                return cell
            
        case .signInBanner:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as! SignInBannerTableViewCell
                cell.backgroundColor = .clear
                cell.delegate = self
                return cell
            
        case .homeEcological:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: cellIndentifier,
                    for: indexPath) as! HomeTableViewCellEcologicalCell
            
                    cell.backgroundColor = .clear
            
                    StyleHelper.commonLayer(layer: cell.savedTreesView.layer)
                    StyleHelper.commonLayer(layer: cell.savedWaterView.layer)
                    StyleHelper.commonLayer(layer: cell.greenScoreView.layer)
               return cell
            
        case .homeDistribution:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as! HomeDistributionTableViewCell
            
                cell.backgroundColor = .clear
                StyleHelper.commonLayer(layer: cell.distributionView.layer)
            
                return cell
        case .homePrinterFavorites:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as! HomePrinterFavoritesTableViewCell

                cell.backgroundColor = .clear
                cell.delegate = self
            
                return cell
            default:
                return UITableViewCell()
        }
    }
}

// MARK: - HomePrinterFavoritesDelegate
extension HomeViewController: HomePrinterFavoritesDelegate {
    func onViewAllPrintersTapped() {
        let storyboard = UIStoryboard(name: "PrintersStoryboard", bundle: nil)
        if let printersVC = storyboard.instantiateViewController(withIdentifier: "PrintersViewController") as? PrintersViewController {
            navigationController?.pushViewController(printersVC, animated: true)
            printersVC.receivedTitle = "Printers List"
        }
    }
}

// MARK: - HomePrinterFavoritesDelegate
extension HomeViewController: SignInBannerTableViewCellDelegate, UIViewControllerTransitioningDelegate, LoginBottomSheetViewControllerDelegate {
    
    func openBottomSheetLogin() {
        LoginManager.presentBottomSheet(from: self, delegate: self)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return CommonPresentationController(presentedViewController: presented, presenting: presenting, height: (presented as? LoginBottomSheetViewController)?.bottomSheetHeight, isDialog: false)
    }
    
    func didLoginSuccessfully() {
        self.dismiss(animated: true, completion: nil)
        
    }
}
