//
//  HomeViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // HomeTableViewCellEcologicalCell
        let cellIdentifiers = [
            "BalanceTableViewCell",
            "SignInBannerTableViewCell",
            "HomeTableViewCellEcologicalCell",
            "HomeDistributionTableViewCell",
            "HomePrinterFavoritesTableViewCell"
        ]
        for cellIdentifier in cellIdentifiers {
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }
}

// MARK: - Table View Cell
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTableViewCell", for: indexPath) as! BalanceTableViewCell
                cell.backgroundColor = .clear
                cell.username.text = "Duy Pham(VN)"
                cell.balance.text = Formater.formatAsUSD(amount: 987654)
                return cell
            
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignInBannerTableViewCell", for: indexPath) as! SignInBannerTableViewCell
                cell.backgroundColor = .clear
                return cell
            
            case 2:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "HomeTableViewCellEcologicalCell",
                    for: indexPath) as! HomeTableViewCellEcologicalCell
            
                    cell.backgroundColor = .clear
            
                    commonLayer(layer: cell.savedTreesView.layer)
                    commonLayer(layer: cell.savedWaterView.layer)
                    commonLayer(layer: cell.greenScoreView.layer)
               return cell
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDistributionTableViewCell", for: indexPath) as! HomeDistributionTableViewCell
            
                cell.backgroundColor = .clear
                commonLayer(layer: cell.distributionView.layer)
            
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomePrinterFavoritesTableViewCell", for: indexPath) as! HomePrinterFavoritesTableViewCell

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
        if let printersViewController = storyboard.instantiateViewController(withIdentifier: "PrintersViewController") as? PrintersViewController {
            navigationController?.pushViewController(printersViewController, animated: true)
        }
    }
}

// MARK: - Card - HomeTableViewCellEcologicalCell
extension HomeViewController {
    private func commonLayer(layer: CALayer) {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.1
    }
}
