//
//  MainTabBarViewController.swift
//  Gespage
//
//  Created by Duy Pham on 30/07/2023.
//

import UIKit

class MainTabBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        renderTabbar()
    }
}

// MARK: - Hide Header Page
extension MainTabBarViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Custom TabBar
extension MainTabBarViewController {
    private func renderTabbar() {
        // Tạo các UIViewController cho từng tab con
        let homeViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateInitialViewController() as! HomeViewController
        let printViewController = UIStoryboard(name: "PrintStoryboard", bundle: nil).instantiateInitialViewController() as! PrintViewController
        let scanViewController = UIStoryboard(name: "ScanStoryboard", bundle: nil).instantiateInitialViewController() as! ScanViewController
        let moreViewController = UIStoryboard(name: "MoreStoryboard", bundle: nil).instantiateInitialViewController() as! MoreViewController

        // Tạo các tab bar item cho mỗi UIViewController
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: ImageHelper.homeIcon, tag: 0)
        printViewController.tabBarItem = UITabBarItem(title: "Print", image: ImageHelper.printerIcon, tag: 1)
        scanViewController.tabBarItem = UITabBarItem(title: "Scan", image: ImageHelper.scanIcon, tag: 2)
        moreViewController.tabBarItem = UITabBarItem(title: "More", image: ImageHelper.moreIcon, tag: 3)

        // Tạo Tab bar controller và thêm các tab vào
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeViewController,
            printViewController,
            scanViewController,
            moreViewController
        ]
        
        // Thiết lập màu nền của TabBar
        let tabBarAppearance = UITabBarAppearance()
        let tabBar = tabBarController.tabBar
        tabBarAppearance.backgroundColor = UIColor.white // Đặt màu nền TabBar theo ý muốn
        tabBar.standardAppearance = tabBarAppearance

        // Thiết lập màu chữ và icon khi tab được chọn (active) và khi không được chọn (inactive)
        let tabBarItemAppearance = UITabBarItemAppearance()
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 51/255, green: 88/255, blue: 156/255, alpha: 1.0), // Màu chữ khi tab được chọn
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold) // Font size 14, Font weight 600 khi tab được chọn
        ]
        let unselectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 160/255, green: 163/255, blue: 189/255, alpha: 1.0), // Màu chữ khi tab không được chọn
            .font: UIFont.systemFont(ofSize: 14, weight: .regular) // Font size 14, Font weight 400 khi tab không được chọn
        ]
        tabBarItemAppearance.selected.titleTextAttributes = selectedAttributes
        tabBarItemAppearance.normal.titleTextAttributes = unselectedAttributes

        // Thiết lập màu icon khi tab được chọn và khi không được chọn
        tabBarItemAppearance.selected.iconColor = UIColor(red: 125/255, green: 185/255, blue: 40/255, alpha: 1.0) // Màu icon khi tab được chọn
        tabBarItemAppearance.normal.iconColor = UIColor(red: 160/255, green: 163/255, blue: 189/255, alpha: 1.0) // Màu icon khi tab không được chọn

        tabBar.standardAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBar.backgroundColor = .white
        
        // Thêm BorderRadius top, left = 16
        tabBar.layer.cornerRadius = 16
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Add Shadow Color
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2) // Adjust the shadow offset as needed
        tabBar.layer.shadowRadius = 4 // Adjust the shadow radius as needed
        tabBar.layer.shadowOpacity = 0.1 // Adjust the shadow opacity as needed

        // Hiển thị BottomNavigationBar
        self.addChild(tabBarController)
        self.view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}
