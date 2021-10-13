//
//  SigninController.swift
//  BWM
//
//  Created by obozhdi on 23/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SwiftyUserDefaults
import Flurry_iOS_SDK
import Alamofire

class SigninController: BaseViewController {
    
    @IBOutlet weak var emailTextField    : BWMTextField!
    @IBOutlet weak var passwordTextField : BWMTextField!
    @IBOutlet weak var fbButtonView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Storyboards.AuthReg.instantiateSigninController().modalPresentationStyle = .fullScreen
        LoginManager().logOut()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userLocation, .userBirthday, .email ])
        loginButton.frame = fbButtonView.bounds
        loginButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loginButton.delegate = self
        fbButtonView.addSubview(loginButton)
        
        setupFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Defaults[.token] != nil {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func setupFields() {
        emailTextField.style    = .email
        passwordTextField.style = .password
    }
    
    private func fieldsAreValid() -> Bool {
        var valid: Bool = false
        
        if emailTextField.isFilled {
            valid = true
        } else {
            valid = false
            Alerts.showCustomErrorMessage(title: "Error", message: "Email incorrect", button: "Try again")
            
            return false
        }
        
        if passwordTextField.isFilled {
            valid = true
        } else {
            valid = false
            Alerts.showCustomErrorMessage(title: "Error", message: "Password incorrect", button: "Try again")
            
            return false
        }
        
        return valid
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //    unblockView()
    }
        
    @IBAction func tapLogin(_ sender: Any) {
        blockSelf()
        if fieldsAreValid() {
            Flurry.logEvent("SignInScreen_signIn")
            dismissKeyboard()
            SignInRequest.fire(login: emailTextField.text!, password: passwordTextField.text!) { (completed) in
                if completed {
                    self.unblockSelf()
//                        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//                            if let screen = segue.destination as? MainTabbarController {
////                                screen.userInfo = self.userInfo
//                                self.navigationController?.pushViewController(screen, animated: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                   let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! MainTabbarController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                        
                }
                 else {
                    self.unblockSelf()
                }
            }
        }
        else {
            self.unblockSelf()
        }
    }
    
}

extension SigninController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            Alerts.showCustomErrorMessage(title: "Error", message: error.localizedDescription, button: "OK")
        case .cancelled:
            break
        case .success( _, _, let accessToken):
            Flurry.logEvent("SignInScreen_facebookSignIn")
            let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,birthday,picture.width(480).height(480)"], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
            
            request.start({ (response, requestResult) in
                switch requestResult{
                case .success(let response):do{
                    
//                   let username = response.dictionaryValue?["first_name"] as? String
//                        print("user",username!)
//
//
//                let firstName = response.dictionaryValue?["first_name"] as? String
//                        print(firstName!)
//
//              let lastName = response.dictionaryValue?["last_name"] as? String
//                        print(lastName!)
//
//                    let gender = response.dictionaryValue?["user_gender"] as? String
//                        print(gender ?? "M")
//                    let image = response.dictionaryValue?["picture"] as? NSDictionary
//                    let data = image?.object(forKey: "data") as? NSDictionary
//                    let url = data?.object(forKey: "url") as? String
//                    print("",url ?? "")
//
//                    let socialId = AccessToken.current?.userId
//                    print("",socialId ?? "")
//                  let email = response.dictionaryValue?["email"] as? String
//                        print("user email  \(email ?? "")")
//
//                     let date = response.dictionaryValue?["birthday"] as? String
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "MM/dd/yyyy"
//                        if let dateObj = formatter.date(from: date!){
//                            formatter.dateFormat = "MM-dd-yyyy"
//                            print("user bday  \(dateObj)")
                            
                            let alert = UIAlertController.init(title: "BWM", message: "Login Successful", preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok", style: .default) { (ok) in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! MainTabbarController
//                                vc.modalPresentationStyle = .fullScreen
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                        
                    
                   // FBSignUpRequest.sharedInstance.fbSocialLogin(username: username ?? "", email: email ?? "", isCustomer: "0", avatarMediaId: "", firstName: firstName ?? "", lastName: lastName ?? "", birthDate: date ?? "", gender: gender ?? "", facebook_id: socialId ?? "")
                    
                }
                
                case .failed(let error):
                    Alerts.showCustomErrorMessage(title: "Error", message: error.localizedDescription, button: "OK")
                    print(error.localizedDescription)
                }
            })
//            FBSignInRequest.fire(accessToken: accessToken.authenticationToken) { (success, error, code) in
//                if success {
//                    self.dismiss(animated: true, completion: nil)
//                }
////                else if code == 422 {
////                    Store.shared.tempFBToken = accessToken.authenticationToken
////                    let userInfo = UserSetupModel()
////                    userInfo.userData["facebookAccessToken"] = accessToken.authenticationToken
////                    let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,birthday"], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
////
////                    request.start({ (response, requestResult) in
////                        switch requestResult{
////                        case .success(let response):
////                            if let email = response.dictionaryValue?["email"] as? String {
////                                userInfo.userData["email"] = email
////                            }
////                            if let date = response.dictionaryValue?["birthday"] as? String {
////                                let formatter = DateFormatter()
////                                formatter.dateFormat = "MM/dd/yyyy"
////                                if let dateObj = formatter.date(from: date){
////                                    formatter.dateFormat = "MM-dd-yyyy"
////                                    userInfo.userData["birthDate"] = formatter.string(from: dateObj)
////                                }
////                            }
////                            userInfo.isFBSignUp = true
////
////                            if let nav = R.storyboard.selection.instantiateInitialViewController(),
////                                let screen = nav.viewControllers.first as? SelectionController {
////                                screen.userInfo = userInfo
////
////                                self.present(nav, animated: true, completion: nil)
////                            }
////                        case .failed(let error):
////                            Alerts.showCustomErrorMessage(title: "Error", message: error.localizedDescription, button: "OK")
////                            print(error.localizedDescription)
////                        }
////                    })
////                }
//                else {
//                    print(error)
//                    LoginManager().logOut()
//                    let alert = UIAlertController.init(title: "BWM", message: "Login Successful", preferredStyle: .alert)
//                    let ok = UIAlertAction.init(title: "Ok", style: .default) { (ok) in
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! MainTabbarController
//                        vc.modalPresentationStyle = .fullScreen
//                        self.present(vc, animated: true, completion: nil)
//                    }
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
    }
    
    
}
