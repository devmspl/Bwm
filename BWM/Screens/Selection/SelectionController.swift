//
//  SelectionController.swift
//  BWM
//
//  Created by obozhdi on 23/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import FacebookLogin

class SelectionController: BaseViewController {
    
    @IBOutlet private weak var freelanceBtn   : UIButton!
    @IBOutlet private weak var customerBtn    : UIButton!
    @IBOutlet private weak var freelanceLabel : UILabel!
    @IBOutlet private weak var customerLabel  : UILabel!
    @IBOutlet private weak var nextBtn        : UIButton!
    
    var userInfo = UserSetupModel()
    
    @IBAction func tapSelection(_ sender: UIButton) {
        if sender == freelanceBtn {
            freelanceBtn.isSelected  = true
            customerBtn.isSelected   = false
            freelanceLabel.textColor = UIColor.init(hex : 0x4A4A4A)
            customerLabel.textColor  = UIColor.init(hex  : 0xA4A4A4)
            Store.shared.tempType = 0
        } else {
            freelanceBtn.isSelected  = false
            customerBtn.isSelected   = true
            freelanceLabel.textColor = UIColor.init(hex : 0xA4A4A4)
            customerLabel.textColor  = UIColor.init(hex  : 0x4A4A4A)
            Store.shared.tempType = 1
        }
        nextBtn.isHidden = false
    }
    
    @IBAction private func onBackButton() {
        LoginManager().logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction private func onSelect() {
        Defaults[.userType] = Store.shared.tempType == 0 ? "freelancer" : "customer"
        userInfo.isCustomer = Store.shared.tempType == 1
        
        if userInfo.isFBSignUp {
            if let screen = R.storyboard.authReg.signUpNameController() {
                screen.userInfo = userInfo
                self.navigationController?.pushViewController(screen, animated: true)
            }
        }
        else {
            if let screen = R.storyboard.authReg.signUpEmailController() {
                screen.userInfo = userInfo
                if Store.shared.tempType == 1{
                    screen.isCustomer = "0"
                }else{
                    screen.isCustomer = "1"
                }
                
                self.navigationController?.pushViewController(screen, animated: true)
            }
        }
    }
    
    //MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let screen = segue.destination as? SignUpEmailController {
//        }
//    }
    
}
