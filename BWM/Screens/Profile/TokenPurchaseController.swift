//
//  TokenPurchaseController.swift
//  BWM
//
//  Created by Serhii on 11/8/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher
import Flurry_iOS_SDK

class TokenPurchaseController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var viewPurchaseLeft: UIView!
    @IBOutlet private weak var viewPurchaseLeftShadow: UIView!
    @IBOutlet private weak var viewPurchaseMid: UIView!
    @IBOutlet private weak var viewPurchaseMidShadow: UIView!
    @IBOutlet private weak var viewPurchaseRight: UIView!
    @IBOutlet private weak var viewPurchaseRightShadow: UIView!
    
    @IBOutlet weak var labelPurchaseLeftPrice: UILabel!
    @IBOutlet weak var labelPurchaseMidPrice: UILabel!
    @IBOutlet weak var labelPurchaseRightPrice: UILabel!
    
    @IBOutlet private weak var viewButtonNow: UIView!
    @IBOutlet private weak var viewButtonNowShadow: UIView!
    
    @IBOutlet private weak var imageAvatar: UIImageView!
    
    var blurEffectView: UIVisualEffectView?
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    var indicator: NVActivityIndicatorView?
    
    //MARK: - Properties
    
    var userImageLink: String = ""
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeUI()

        blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView?.frame = UIScreen.main.bounds
        
        if let url = URL(string: self.userImageLink){
            self.imageAvatar.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        else {
            self.imageAvatar.image = R.image.main.logo()
        }
        
        blurEffectView?.isUserInteractionEnabled = false
        indicator?.alpha = 0.0
        
        let rect = CGRect(x: UIScreen.main.bounds.width / 2 - 80 / 2, y: UIScreen.main.bounds.height / 2 - 80 / 2, width: 80, height: 80)
        indicator = NVActivityIndicatorView(frame: rect, type: .ballGridPulse, color: UIColor.init(hex: 0xED4756), padding: 2)
        
        self.view.addSubview(blurEffectView!)
        blurEffectView?.contentView.addSubview(indicator!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(onPurhaseHandled(_:)), name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.removeObserver(self, name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let screen = segue.destination as? TextViewController {
            if segue.identifier == R.segue.tokenPurchaseController.showPrivacy.identifier {
                screen.textType = .privacyPolicy
            }
            else if segue.identifier == R.segue.tokenPurchaseController.showTerms.identifier {
                screen.textType = .termsOfUse
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func onButton5Tokens() {
        if let purchase = IAPHelper.shared.purchaseForKey(PurchaseId.credits5.rawValue) {
            self.blockView()
            Flurry.logEvent("TokenPurchase_buy5")
            IAPHelper.shared.buyProduct(purchase)
        }
    }
    
    @IBAction private func onButton10Tokens() {
        if let purchase = IAPHelper.shared.purchaseForKey(PurchaseId.credits10.rawValue) {
            self.blockView()
            Flurry.logEvent("TokenPurchase_buy10")
            IAPHelper.shared.buyProduct(purchase)
        }
    }
    
    @IBAction private func onButton25Tokens() {
        if let purchase = IAPHelper.shared.purchaseForKey(PurchaseId.credits25.rawValue) {
            self.blockView()
            Flurry.logEvent("TokenPurchase_buy25")
            IAPHelper.shared.buyProduct(purchase)
        }
    }
    
    @IBAction func onBackButton() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onPurhaseHandled(_ notification: Notification) {
        self.unblockView()
        
        if let error = notification.userInfo?["error"] as? NSError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    //MARK: - Private methods
    
    func updatePriceLabels() {
        guard let token5 = IAPHelper.shared.purchaseForKey(PurchaseId.credits5.rawValue),
            let token10 = IAPHelper.shared.purchaseForKey(PurchaseId.credits10.rawValue),
            let token25 = IAPHelper.shared.purchaseForKey(PurchaseId.credits25.rawValue) else { return }
        
        self.labelPurchaseLeftPrice.text = token5.formattedTokenPrice + " / Token"
        self.labelPurchaseMidPrice.text = token25.formattedTokenPrice + " / Token"
        self.labelPurchaseRightPrice.text = token10.formattedTokenPrice + " / Token"
    }
    
    private func customizeUI() {
        self.imageAvatar.layer.borderColor = UIColor.lightGray.cgColor
        self.imageAvatar.layer.borderWidth = 2.0
        
        self.setBorders(toView: self.viewPurchaseLeft)
        self.setShadow(toView: self.viewPurchaseLeftShadow)
        
        self.setBorders(toView: self.viewPurchaseMid)
        self.setShadow(toView: self.viewPurchaseMidShadow)
        
        self.setBorders(toView: self.viewPurchaseRight)
        self.setShadow(toView: self.viewPurchaseRightShadow)
        
        self.setBorders(toView: self.viewButtonNow)
        self.setShadow(toView: self.viewButtonNowShadow)
        
        self.updatePriceLabels()
    }
    
    private func setBorders(toView view: UIView) {
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
    }
    private func setShadow(toView view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
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
