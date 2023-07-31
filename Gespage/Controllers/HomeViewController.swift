//
//  HomeViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit

class HomeViewController: UIViewController {

//    @IBOutlet weak var distributionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        customUIView(layer: savedWaterView.layer)
//        customUIView(layer: savedTreesView.layer)
//        customUIView(layer: distributionView.layer)
//        customUIView(layer: greenScoreView.layer)
    }
}

// MARK: - SavedTrees, Green-Score
extension HomeViewController {
    private func customUIView(layer: CALayer) {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.1
    }
}
