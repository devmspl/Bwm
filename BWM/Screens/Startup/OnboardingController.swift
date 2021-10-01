//
//  OnboardingController.swift
//  BWM
//
//  Created by Serhii on 10/14/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

class OnboardingController: UIViewController {
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nextButton: UIButton!
    
    private var pageController: UIPageViewController!
    private let screenCount: Int = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController = R.storyboard.start.pageVC()!
        
        pageController.dataSource = self
        pageController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addChildViewController(pageController)
        pageController.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(pageController.view)
        
        if let screen = self.itemForIndex(0) {
            pageController.setViewControllers([screen], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @IBAction private func onSkipButton(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "AuthReg", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigninController") as! SigninController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func onNextButton(_ sender: Any?) {
        if let index = (pageController.viewControllers?.first as? OnboardingItemController)?.index {
            if index == screenCount-1 {
                self.onSkipButton(nil)
            }
            else {
                let nextIndex = index + 1
                
                guard nextIndex < screenCount else { return }
                self.updateUI(forIndex: nextIndex)
                self.pageController.setViewControllers([self.itemForIndex(nextIndex)!], direction: .forward, animated: true)
            }
        }
    }
    
    //MARK: - Private methods
    
    fileprivate func updateUI(forIndex index: Int) {
        self.pageControl.currentPage = index
        
        if index == screenCount-1 {
            self.nextButton.setTitle("FINISH", for: .normal)
        }
        else {
            self.nextButton.setTitle("NEXT", for: .normal)
        }
    }
}

extension OnboardingController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let screen = pendingViewControllers.first as? OnboardingItemController {
            self.updateUI(forIndex: screen.index)
        }
    }
}

extension OnboardingController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = (pageController.viewControllers?.first as? OnboardingItemController)?.index else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        if previousIndex >= 0 {
            return self.itemForIndex(previousIndex)
        }
        else {
            return nil
        }

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = (pageController.viewControllers?.first as? OnboardingItemController)?.index else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < screenCount else { return nil }
        
        return self.itemForIndex(nextIndex)
    }
    
    func itemForIndex(_ index:Int) -> OnboardingItemController? {
        if let screen = R.storyboard.start.onboardingItemController() {
            screen.index = index
            return screen
        }
        
        return nil
    }
}
