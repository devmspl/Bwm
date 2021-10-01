//
//  BaseTabbarController.swift
//  BWM
//
//  Created by obozhdi on 22/06/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseTabbarController: UITabBarController {
  
  private var blurEffectView: UIVisualEffectView?
  private let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
  private var indicator: NVActivityIndicatorView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //view.addInputVisibilityController()
    
    blurEffectView = UIVisualEffectView(effect: nil)
    blurEffectView?.frame = UIScreen.main.bounds
    
    blurEffectView?.isUserInteractionEnabled = false
    indicator?.alpha = 0.0
    
    let rect = CGRect(x: UIScreen.main.bounds.width / 2 - 80 / 2, y: UIScreen.main.bounds.height / 2 - 80 / 2, width: 80, height: 80)
    indicator = NVActivityIndicatorView(frame: rect, type: .ballGridPulse, color: UIColor.init(hex: 0xED4756), padding: 2)
    
    self.view.addSubview(blurEffectView!)
    blurEffectView?.contentView.addSubview(indicator!)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    
    /*UITabBar.appearance().shadowImage = UIImage()
    UITabBar.appearance().backgroundImage = UIImage()*/
  }
  
  func blockView() {
    indicator?.startAnimating()
    UIView.animate(withDuration: 0.25) {
      self.blurEffectView?.effect = self.blurEffect
      self.indicator?.alpha = 1.0
      self.view.setNeedsDisplay()
    }
  }
  
  func unblockView() {
    UIView.animate(withDuration: 0.25, animations: {
      self.blurEffectView?.effect = nil
      self.view.setNeedsDisplay()
      self.indicator?.alpha = 0.0
    }) { completed in
      self.indicator?.stopAnimating()
    }
  }
  
}
