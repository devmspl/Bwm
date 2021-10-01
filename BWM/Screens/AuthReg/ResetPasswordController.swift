//
//  ResetPasswordController.swift
//  BWM
//
//  Created by obozhdi on 23/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class ResetPasswordController: BaseViewController {
    
    @IBOutlet weak var emailTextField    : BWMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.style    = .email
    }
    
    //MARK: - Private methods
    
    private func fieldsAreValid() -> Bool {
        var valid: Bool = false
        
        if emailTextField.isFilled {
            valid = true
        } else {
            valid = false
            Alerts.showCustomErrorMessage(title: "Error", message: "Email incorrect", button: "Try again")
            
            return false
        }
        
        return valid
    }
    
    @IBAction func tapSend(_ sender: Any) {
        blockSelf()
        if fieldsAreValid() {
            dismissKeyboard()
            Flurry.logEvent("ResetPasswordScreen_reset")
            ChangePasswordRequest.fire(email: emailTextField.text!) { (completion) in
                if completion {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: false, completion: nil)
                        self.unblockSelf()
                    }
                }
                else {
                    self.unblockSelf()
                }
            }
        }
        else {
            unblockSelf()
        }
    }
}
