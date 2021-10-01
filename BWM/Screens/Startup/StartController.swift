//
//  StartController.swift
//  BWM
//
//  Created by obozhdi on 16/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Alamofire
import Foundation
import UIKit
import SwiftyUserDefaults

class StartController: BaseViewController {
    
    private var ethnicitiesLoaded: Bool = false
    private var categoriesLoaded: Bool = false
    private var videoShown: Bool = false
    
    private var isInitialDataLoaded: Bool {
        return self.ethnicitiesLoaded && self.categoriesLoaded
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isInitialDataLoaded {
            self.setRootController()
        }
        else {
            self.getInitialData()
        }
    }
    
    private func getInitialData() {
        EthnicitiesRequest.fire { [weak self] (_, _) in
            self?.ethnicitiesLoaded = true
            self?.proceedToStartScreen()
        }
        CategoryRequest.fire { [weak self] (_, _) in
            self?.categoriesLoaded = true
            self?.proceedToStartScreen()
        }
    }
    
    private func proceedToStartScreen() {
        if self.isInitialDataLoaded {
            LocationManager.shared.getLocation { (_) in
                self.setRootController()
            }
        }
    }
    
    private func setRootController() {
        if Defaults[.onboarding] != true {
            Defaults[.onboarding] = true
            let screen = R.storyboard.start.onboardingController()!
            PurchaseUtils.shared.shouldShowAfterTutorial = true
            self.present(screen, animated: true, completion: nil)
        }
        else if !videoShown {
            StartVideoRequest.fire { (url, uId, userImage) in
                self.videoShown = true
                if let url = url,
                    let uId = uId,
                    let controller = R.storyboard.start.startVideoController() {
                    controller.videoUrl = url
                    controller.userId = uId
                    controller.userAvatarUrl = userImage
                    self.present(controller, animated: true, completion: nil)
                }
                else {
                    self.instantiateMainController()
                }
            }
        }
        else {
            self.instantiateMainController()
        }
    }
    
    private func instantiateMainController() {
        guard let window = UIApplication.shared.delegate?.window else { return }
        if Defaults[.token] != nil {
            window?.rootViewController = Storyboards.Main.instantiateInitialViewController()
        } else {
//            Storyboards.AuthReg.instantiateInitialViewController().modalPresentationStyle = .fullScreen
//            self.present(Storyboards.AuthReg.instantiateInitialViewController(), animated : true, completion : nil)
            let storyboard = UIStoryboard(name: "AuthReg", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SigninController") as! SigninController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    static func handleUnautorized() {
        Defaults[.token] = nil
        let alert = UIAlertController(title: "Current session has been expired", message: "Please log in", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let screen = R.storyboard.start.startController() {
                guard let window = UIApplication.shared.delegate?.window else { return }
                window?.rootViewController = screen
            }
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
