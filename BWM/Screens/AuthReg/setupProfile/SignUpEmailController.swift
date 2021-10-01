//
//  SignUpEmailController.swift
//  BWM
//
//  Created by Serhii on 10/16/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class SignUpEmailController: BaseViewController {
    
    @IBOutlet private weak var fieldEmail: BWMTextField!
    @IBOutlet private weak var fieldPassword: BWMTextField!
    @IBOutlet private weak var fieldConfirm: BWMTextField!
    
    @IBOutlet private weak var labelStep: UILabel!
    
    var userInfo: UserSetupModel!
    var isCustomer = ""
    fileprivate var isFbSignUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("SignUpScreen_start")
        
        setupFields()
        setupStepLabel()
    }
    
    //MARK: - Private methods
    
    private func setupStepLabel() {
        
        let stepNumberStr = NSMutableAttributedString(string: "1",
                                                      attributes: [
                                                        NSAttributedStringKey.foregroundColor : UIColor.lightRed,
                                                        NSAttributedStringKey.font : UIFont(name: "PingFangSC-Medium", size: 28.0)!
            ])
        var stepCount = userInfo.isCustomer ? 2 : 4
        if self.userInfo.isEditing {
            stepCount -= 1
        }
        let stepStr = NSAttributedString(string: " / \(stepCount)\nSTEPS",
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.lightGray,
                NSAttributedStringKey.font : UIFont(name: "PingFangSC-Regular", size: 13.0)!
            ])
        let finalStr = NSMutableAttributedString()
        finalStr.append(stepNumberStr)
        finalStr.append(stepStr)
        
        labelStep.attributedText = finalStr
    }
    
    private func setupFields() {
        fieldEmail.style = .email
        fieldConfirm.style = .password
        fieldPassword.style = .password
    }
    
    private func validateFields() -> Bool {
        var valid: Bool = true
        var errorMessage: String = ""
        if !fieldEmail.isFilled {
            valid = false
            errorMessage += "Email incorrect\n"
        }
        
        if !fieldPassword.isFilled {
            valid = false
            errorMessage += "Password is too short\n"
        }
        
        /*if fieldConfirm.isFilled {
         valid = false
         errorMessage += "Confirmation is too short"
         }*/
        
        if fieldPassword.text != fieldConfirm.text {
            valid = false
            errorMessage += "Passwords dont match\n"
        }
        
        if !valid {
            Alerts.showCustomErrorMessage(title: "Error", message: errorMessage, button: "OK")
        }
        
        return valid
    }
    
    @IBAction func nextTapped(_ sender: Any) {
    }
    //MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !self.isFbSignUp {
            return validateFields()
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !self.isFbSignUp {
            self.userInfo.userData["email"] = fieldEmail.text
            self.userInfo.userData["password"] = fieldPassword.text
        }
        
        if let screen = segue.destination as? SignUpNameController {
            screen.userInfo = self.userInfo
            screen.email = fieldEmail.text!
            screen.isCustomer = isCustomer
            screen.password = fieldPassword.text!
            print("iscustomer",isCustomer)
        }
    }
}

//extension SignUpEmailController: LoginButtonDelegate {
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        switch result {
//        case .failed(let error):
//            Alerts.showCustomErrorMessage(title: "Error", message: error.localizedDescription, button: "OK")
//        case .cancelled:
//            break
//        case .success( _, _, let accessToken):
//            Store.shared.tempFBToken = accessToken.authenticationToken
//            self.userInfo.userData["facebookAccessToken"] = accessToken.authenticationToken
//            let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,birthday"], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
//            
//            request.start({ (response, requestResult) in
//                switch requestResult{
//                case .success(let response):
//                    if let email = response.dictionaryValue?["email"] as? String {
//                        self.userInfo.userData["email"] = email
//                    }
//                    //                    if let name = response.dictionaryValue?["first_name"] as? String, let last = response.dictionaryValue?["last_name"] as? String {
//                    //                        self.userInfo.userData["firstName"] = name
//                    //                        self.userInfo.userData["lastName"] = last
//                    //                    }
//                    if let date = response.dictionaryValue?["birthday"] as? String {
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "MM/dd/yyyy"
//                        if let dateObj = formatter.date(from: date){
//                            formatter.dateFormat = "MM-dd-yyyy"
//                            self.userInfo.userData["birthDate"] = formatter.string(from: dateObj)
//                        }
//                    }
//                    self.userInfo.isFBSignUp = true
//                    self.isFbSignUp = true
//                    self.performSegue(withIdentifier: R.segue.signUpEmailController.signUpStep2.identifier, sender: self)
//                case .failed(let error):
//                    Alerts.showCustomErrorMessage(title: "Error", message: error.localizedDescription, button: "OK")
//                    print(error.localizedDescription)
//                }
//            })
//        }
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: LoginButton) {
//    }
//}
