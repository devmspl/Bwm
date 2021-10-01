//
//  IAPHelper.swift
//  BWM
//
//  Created by Serhii on 8/30/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import StoreKit
import SwiftyUserDefaults

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject  {
    
    static let shared: IAPHelper = IAPHelper()
    
    private let productIdentifiers: Set<ProductIdentifier> = [
        PurchaseId.credits5.rawValue,
        PurchaseId.credits10.rawValue,
        PurchaseId.credits25.rawValue,
        PurchaseId.credits50.rawValue,
        PurchaseId.credits100.rawValue,
        PurchaseId.month.rawValue,
        PurchaseId.quarter.rawValue,
        PurchaseId.halfYear.rawValue,
    ]
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    private var _availablePurchases: [Purchase] = []
    var availablePurchases: [Purchase] {
        return _availablePurchases
    }
    
    func purchaseForKey(_ id: ProductIdentifier) -> Purchase? {
        for item in _availablePurchases {
            if item.product.productIdentifier == id {
                return item
            }
        }
        return nil
    }
    
    func updatePurchasesInfo() {
        self.requestProducts { [weak self] (success, products) in
            if success,
                let products = products {
                self?._availablePurchases.removeAll()
                for item in products {
                    self?._availablePurchases.append(Purchase(product: item))
                }
            }
        }
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    
    func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    func buyProduct(_ purchase: Purchase) {
        print("Buying \(purchase.product.productIdentifier)...")
        let payment = SKPayment(product: purchase.product)
        SKPaymentQueue.default().add(payment)
    }
    
    class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil)
                break
            case .deferred:
                NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil)
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete payment...")
        if let purchaseId = PurchaseId(rawValue: transaction.payment.productIdentifier) {
            self.handlePurchase(isSubscription: purchaseId.isSubscription)
        }
        
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore product... \(productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("transaction fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription {
            print("Transaction Error: \(localizedDescription)")
            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil, userInfo: ["error": transactionError])
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /*private func increaseBalance(purchaseId: PurchaseId) {
        IncreaseBalanceRequest.fire(tokenCount: purchaseId.value) { (success) in
            DispatchQueue.main.async { [success]
                NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil)
                if success {
                    Alerts.showCustomErrorMessage(title: "Success", message: "New tokens have been added", button: "OK")
                }
            }
        }
    }*/
    
    private func handlePurchase(isSubscription: Bool) {
        if let data = self.loadReceipt() {
            if Defaults[.token] != nil {
                UploadReceiptRequest.fire(isSubscription: isSubscription, data: data) { [isSubscription] (success) in
                    if success {
                        DispatchQueue.main.async {
                            if isSubscription {
                                Defaults[.userIsPro] = true
                            }
                            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil)
                            let message = isSubscription ? "Your profile is Pro now" : "New tokens have been added"
                            Alerts.showCustomErrorMessage(title: "Success", message: message, button: "OK")
                        }
                    }
                    else {
                        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil)
                    }
                }
            }
        }
    }
    
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
}

