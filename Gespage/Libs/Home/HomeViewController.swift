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
        let nib = UINib(nibName: "HomeTableViewCellEcologicalCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeTableViewCellEcologicalCell")
    }
}

// MARK: - Table View Cell
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCellEcologicalCell", for: indexPath) as! HomeTableViewCellEcologicalCell
                cell.backgroundColor = .clear
                cell.savedTreesView.layer.cornerRadius = 12
                cell.savedWaterView.layer.cornerRadius = 12
                cell.greenScoreView.layer.cornerRadius = 12
               return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDistributionCell", for: indexPath) as! HomeDistributionCell
            cell.backgroundColor = .clear
                cell.distributionLabel.text = "Distribution"
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomePrinterFavoritesCell", for: indexPath) as! HomePrinterFavoritesCell
                cell.favoritePrintLabel.text = "Favorite Printers"
                return cell
            default:
                return UITableViewCell()
        }
    }
}
