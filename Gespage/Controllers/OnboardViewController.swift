//
//  OnboardViewController.swift
//  Gespage
//
//  Created by Duy Pham on 28/07/2023.
//

import UIKit

class OnboardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
   
    var titleArrays = [
        "Secure solution",
        "Mobile Printing",
        "Environmental friendly"
    ]
    
    var subTitleArrays = [
        "Gespage Mobile is a secure mobile print solution that allows you to easily print from your smartphone or tablet",
        "Easily print to printers on your network without having to install them on your smartphone. This service is compatible with various documents such as pdf, office, images...",
        "Track the environmental impact of your documents and try to improve it"
    ]
    
    var imageArrays = [
        ImageHelper.onBoard1,
        ImageHelper.onBoard2,
        ImageHelper.onBoard3
    ]
}

// MARK: - View Life Cycle
extension OnboardViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        doneShow(false)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
}

// MARK: - IBActions
extension OnboardViewController {
    @IBAction func skipButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "WelcomeStoryboard", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        showItem(at: pageControl.currentPage)
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "WelcomeStoryboard", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
}

// MARK: - Private Functions
extension OnboardViewController {
    private func skipShow(_ bool: Bool) {
        skipButton.isHidden = !bool
    }
    
    private func doneShow(_ bool: Bool) {
        doneButton.isHidden = !bool
    }
    
    private func showItem(at index: Int) {
        pageControl.page = index
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
}

// MARK: - CollectionView
extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardCell", for: indexPath) as! OnboardCell
        
        cell.onboardImageView.image = imageArrays[indexPath.row]
        cell.headingLabel.text = titleArrays[indexPath.row]
        cell.subHeadingLabel.text = subTitleArrays[indexPath.row]
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        pageControl.page = page
        skipShow(page != 2)
        doneShow(page == 2)
    }
    
}

// MARK: - UIPageControl
extension UIPageControl {
    var page: Int {
        get {
            return currentPage
        }
        set {
            currentPage = newValue
            // setIndicatorImage(ImageHelper.pageSelected, forPage: newValue)
            // for index in 0..<numberOfPages where index != newValue {
            //     preferredIndicatorImage = ImageHelper.page
            // }
        }
    }
}
