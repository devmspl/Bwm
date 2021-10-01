//
//  StartVideoController.swift
//  BWM
//
//  Created by obozhdi on 19/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import Foundation
import UIKit
import TTInputVisibilityController
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    var blurEffectView: UIVisualEffectView?
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    var indicator: NVActivityIndicatorView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView?.frame = UIScreen.main.bounds
        
        blurEffectView?.isUserInteractionEnabled = false
        indicator?.alpha = 0.0
        
        let rect = CGRect(x: UIScreen.main.bounds.width / 2 - 80 / 2, y: UIScreen.main.bounds.height / 2 - 80 / 2, width: 80, height: 80)
        indicator = NVActivityIndicatorView(frame: rect, type: .ballGridPulse, color: UIColor.init(hex: 0xED4756), padding: 2)
        
        self.view.addSubview(blurEffectView!)
        blurEffectView?.contentView.addSubview(indicator!)
        
        //    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.init(hex: 0xFF6265)
        //navigationItem.backBarButtonItem?.title = ""
        setupBackButton()
    }
    
    func blockView() {
        (tabBarController as? BaseTabbarController)?.blockView()
    }
    
    func unblockView() {
        (tabBarController as? BaseTabbarController)?.unblockView()
    }
    
    func blockNav() {
        
    }
    
    func unblockNav() {
        
    }
    
    func blockSelf() {
        indicator?.startAnimating()
        UIView.animate(withDuration: 0.25) {
            self.blurEffectView?.effect = self.blurEffect
            self.indicator?.alpha = 1.0
            self.view.setNeedsDisplay()
        }
    }
    
    func unblockSelf() {
        UIView.animate(withDuration: 0.25, animations: {
            self.blurEffectView?.effect = nil
            self.view.setNeedsDisplay()
            self.indicator?.alpha = 0.0
        }) { completed in
            self.indicator?.stopAnimating()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension BaseViewController {
    
    private func setupBackButton() {
        navigationController?.navigationBar.backIndicatorImage = R.image.navbar.backButton()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = R.image.navbar.backButton()
        let customBackButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = customBackButton
    }
    
}
