//
//  Subscription.swift
//  BWM
//
//  Created by Serhii on 8/30/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import StoreKit

enum PurchaseId: String {
    case credits5 = "com.bwmapp.bookwithme.5BWMCredit"
    case credits10 = "com.bwmapp.bookwithme.10BWMCredit"
    case credits25 = "com.bwmapp.bookwithme.25BWMCredit"
    case credits50 = "com.bwmapp.bookwithme.50BWMCredit"
    case credits100 = "com.bwmapp.bookwithme.100BWMCredit"
    case month = "Monthly_pro"
    case quarter = "PRO_3_Months"
    case halfYear = "PRO_6_Months"
    
    var value: Int {
        switch self {
        case .credits5:
            return 5
        case .credits10:
            return 10
        case .credits25:
            return 25
        case .credits50:
            return 50
        case .credits100:
            return 100
        default:
            return 0
        }
    }
    
    var isSubscription: Bool {
        switch self {
        case .month, .quarter, .halfYear:
            return true
        default:
            return false
        }
    }
}

private var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.formatterBehavior = .behavior10_4
    formatter.currencyDecimalSeparator = "."
    
    return formatter
}()

struct Purchase {
    let product: SKProduct
    let formattedPrice: String
    
    var formattedMonthPrice: String {
        if self.product.productIdentifier == PurchaseId.halfYear.rawValue {
            let price = product.price.dividing(by: NSDecimalNumber(value: 6))
            return formatter.string(from: price) ?? ""
            
        }
        else if self.product.productIdentifier == PurchaseId.quarter.rawValue {
            let price = product.price.dividing(by: NSDecimalNumber(value: 3))
            return formatter.string(from: price) ?? ""
        }
        else {
            return formattedPrice
        }
    }
    
    var formattedTokenPrice: String {
        if let purchaseId = PurchaseId(rawValue: self.product.productIdentifier) {
            if purchaseId.isSubscription {
                return formattedPrice
            }
            
            let price = product.price.dividing(by: NSDecimalNumber(value: purchaseId.value))
            return formatter.string(from: price) ?? ""
        }
        else {
            return formattedPrice
        }
    }
    
    init(product: SKProduct) {
        self.product = product
        if formatter.locale != self.product.priceLocale {
            formatter.locale = self.product.priceLocale
        }
        
        formattedPrice = formatter.string(from: product.price) ?? "\(product.price)"
    }
}
