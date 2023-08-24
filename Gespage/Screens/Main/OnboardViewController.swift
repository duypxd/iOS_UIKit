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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
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
        let firstLaunchValue = UserDefaults.standard.bool(forKey: AppDefaultsKeys.firstLaunchKey)
        let skipWelcomeValue = UserDefaults.standard.bool(forKey: AppDefaultsKeys.skipWelcomeKey)
        print("skipWelcomeValue \(skipWelcomeValue)")
        if firstLaunchValue {
            onSkipOnboardView()
            if skipWelcomeValue {
                onReplaceMainPage()
            }
        }
        
        
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
    private func onReplaceMainPage() {
        navigationController?.setViewControllers([MainTabBarViewController()], animated: true)
        UserDefaults.standard.set(true, forKey: AppDefaultsKeys.skipWelcomeKey)
    }
    
    private func onSkipOnboardView() {
        let storyboard = UIStoryboard(name: "WelcomeStoryboard", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.setViewControllers([welcomeViewController], animated: true)
        }
        UserDefaults.standard.set(true, forKey: AppDefaultsKeys.firstLaunchKey)
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        onSkipOnboardView()
    }
    
    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        showItem(at: pageControl.currentPage)
        skipShow(pageControl.currentPage != 2)
        doneShow(pageControl.currentPage == 2)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        let currentPage = pageControl.currentPage + 1;
        if pageControl.currentPage == 2 {
            onSkipOnboardView()
        } else {
            showItem(at: currentPage)
            doneShow(currentPage == 2)
            skipShow(currentPage != 2)
        }
    }
}

// MARK: - Private Functions
extension OnboardViewController {
    private func skipShow(_ bool: Bool) {
        skipButton.isHidden = !bool
    }
    
    private func doneShow(_ bool: Bool) {
        nextButton.setTitle( bool ? "Done" : "Next", for: .normal)
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
