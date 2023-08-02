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
        tableView.register(
            UINib(nibName: "HomeTableViewCellEcologicalCell", bundle: nil),
            forCellReuseIdentifier: "HomeTableViewCellEcologicalCell")
        // HomeTableViewCellEcologicalCell
        tableView.register(
            UINib(nibName: "HomeDistributionTableViewCell", bundle: nil),
            forCellReuseIdentifier: "HomeDistributionTableViewCell")
        // HomePrinterFavoritesTableViewCell
        tableView.register(
            UINib(nibName: "HomePrinterFavoritesTableViewCell", bundle: nil),
            forCellReuseIdentifier: "HomePrinterFavoritesTableViewCell")
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
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "HomeTableViewCellEcologicalCell",
                    for: indexPath) as! HomeTableViewCellEcologicalCell
            
                    cell.backgroundColor = .clear
            
                    commonLayer(layer: cell.savedTreesView.layer)
                    commonLayer(layer: cell.savedWaterView.layer)
                    commonLayer(layer: cell.greenScoreView.layer)
               return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDistributionTableViewCell", for: indexPath) as! HomeDistributionTableViewCell
            
                cell.backgroundColor = .clear
                commonLayer(layer: cell.distributionView.layer)
            
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomePrinterFavoritesTableViewCell", for: indexPath) as! HomePrinterFavoritesTableViewCell
                
                cell.backgroundColor = .clear
            
                return cell
            default:
                return UITableViewCell()
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
