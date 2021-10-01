//
//  SubscriptionsController.swift
//  BWM
//
//  Created by obozhdi on 19/05/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher
import Flurry_iOS_SDK

class SubscriptionsController: TokenPurchaseController {
    
    //MARK: - Properties
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updatePriceLabels() {
        guard let left = IAPHelper.shared.purchaseForKey(PurchaseId.month.rawValue),
            let mid = IAPHelper.shared.purchaseForKey(PurchaseId.quarter.rawValue),
            let right = IAPHelper.shared.purchaseForKey(PurchaseId.halfYear.rawValue) else { return }
        
        self.labelPurchaseLeftPrice.text = left.formattedPrice + " /\nmonth"
        self.labelPurchaseMidPrice.text = "then " + mid.formattedPrice + " /\n3 months"
        self.labelPurchaseRightPrice.text = right.formattedPrice + " /\n6 months"
    }
    
    //MARK: - Actions
    
    @IBAction private func onButtonMonth() {
        if let purchase = IAPHelper.shared.purchaseForKey(PurchaseId.month.rawValue) {
            self.blockView()
            Flurry.logEvent("SubscriptionPurchase_buyMonth")
            IAPHelper.shared.buyProduct(purchase)
        }
    }
    
    @IBAction private func onButton3Months() {
        if let purchase = IAPHelper.shared.purchaseForKey(PurchaseId.quarter.rawValue) {
            self.blockView()
            Flurry.logEvent("SubscriptionPurchase_buy3Months")
            IAPHelper.shared.buyProduct(purchase)
        }
    }
    
    @IBAction private func onButton6Months() {
        if let purchase = IAPHelper.shared.purchaseForKey(PurchaseId.halfYear.rawValue) {
            self.blockView()
            Flurry.logEvent("SubscriptionPurchase_buy6Months")
            IAPHelper.shared.buyProduct(purchase)
        }
    }
    
    //MARK: - Private methods
}
