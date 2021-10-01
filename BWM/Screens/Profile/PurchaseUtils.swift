//
//  PurchaseUtils.swift
//  BWM
//
//  Created by Serhii on 12/30/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

/*1st start of the app after tutorial (can skip)
 each 3rd profile open (can skip)
 each 3rd tap on user on map screen (can skip)
 each 3rd search (can skip)
 each 2nd check Stat ( can skip)
 each 2nd tap of alien location (can skip)
 each 3rd tap on alien media (can  skip)
 each 3rd add to favorites (can skip)
 each time turn on live tracking (can’t skip)
 settings - Go Premium point at the top
 open message from client (can't skip)*/

enum PurchaseShowcase {
    case tutorial
    case profile
    case profileMap
    case search
    case statistic
    case alienLocation
    case alienMedia
    case addFavorites
    case tracking
}

class PurchaseUtils {
    
    static var shared: PurchaseUtils = PurchaseUtils()
    private init() {}
    
    private var profileCounter: Int = 0
    private var profileMapCounter: Int = 0
    private var searchCounter: Int = 0
    private var statisticsCounter: Int = 0
    private var locationCounter: Int = 0
    private var mediaCounter: Int = 0
    private var favoritesCounter: Int = 0
    
    var shouldShowAfterTutorial: Bool = false
    
    func checkOnScreen(_ screen: UIViewController, sCase: PurchaseShowcase) {
        self.updateForCase(sCase)
        
        if self.checkShouldShow(forCase: sCase) {
            if sCase == .tutorial {
                shouldShowAfterTutorial = false
            }
            if let vc = R.storyboard.profileBig.subscriptionsController(),
                Defaults[.userIsPro] != true {
                screen.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    private func updateForCase(_ sCase: PurchaseShowcase) {
        switch sCase {
        case .profile:
            profileCounter = profileCounter < 3 ? profileCounter+1 : 0
        case .profileMap:
            profileMapCounter = profileMapCounter < 3 ? profileMapCounter+1 : 0
        case .search:
            searchCounter = searchCounter < 3 ? searchCounter+1 : 0
        case .statistic:
            statisticsCounter = statisticsCounter < 2 ? statisticsCounter+1 : 0
        case .alienLocation:
            locationCounter = locationCounter < 2 ? locationCounter+1 : 0
        case .alienMedia:
            mediaCounter = mediaCounter < 3 ? mediaCounter+1 : 0
        case .addFavorites:
            favoritesCounter = favoritesCounter < 3 ? favoritesCounter+1 : 0
        default: break
        }
    }
    
    private func checkShouldShow(forCase sCase: PurchaseShowcase) -> Bool {
        switch sCase {
        case .tutorial:
            return shouldShowAfterTutorial
        case .profile:
            return profileCounter == 3
        case .profileMap:
            return profileMapCounter == 3
        case .search:
            return searchCounter == 3
        case .statistic:
            return statisticsCounter == 2
        case .alienLocation:
            return locationCounter == 2
        case .alienMedia:
            return mediaCounter == 3
        case .addFavorites:
            return favoritesCounter == 3
        case .tracking:
            return true
        }
    }
}
