//
//  CreateNewPasswordController.swift
//  BWM
//
//  Created by obozhdi on 23/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit

class CreateNewPasswordController: BaseViewController {
    
    @IBOutlet weak var confirmPassTf    : BWMTextField!
    @IBOutlet weak var passwordTf       : BWMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Private methods
    
    private func fieldsAreValid() -> Bool {
        var valid: Bool = false
        
        if passwordTf.isFilled {
            valid = true
        } else {
            valid = false
            Alerts.showCustomErrorMessage(title: "Error", message: "Password incorrect", button: "Try again")
            
            return false
        }
        
        if passwordTf.text != confirmPassTf.text {
            valid = false
            Alerts.showCustomErrorMessage(title: "Error", message: "Password and confirmation don't match", button: "Try again")
            
            return false
        }
        
        return valid
    }
    
    @IBAction func tapSend(_ sender: Any) {
        blockSelf()
        if fieldsAreValid() {
            dismissKeyboard()
            
            UpdatePasswordRequest.fire(newPassword: passwordTf.text!) { (completion) in
                if completion {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.navigationController?.popViewController(animated: true)
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
