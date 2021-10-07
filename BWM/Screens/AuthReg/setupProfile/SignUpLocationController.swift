//
//  SignUpLocationController.swift
//  BWM
//
//  Created by Serhii on 10/16/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Flurry_iOS_SDK
import Alamofire

class SignUpLocationController: BaseViewController {

    @IBOutlet private weak var fieldAddress: BWMFlatTextField!
    @IBOutlet private weak var labelCode: UILabel!
    @IBOutlet private weak var labelStep: UILabel!
    
    @IBOutlet private weak var labelScreenTitle: UILabel!
    
    @IBOutlet private weak var viewCode: UIView!
    @IBOutlet private weak var constraintViewCodeHeight: NSLayoutConstraint!
    
    
    var userInfo: UserSetupModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        labelScreenTitle.text = userInfo.isEditing ? "Edit account" : "New Account"
//        Flurry.logEvent("SignUpScreen_location")
//        if !self.userInfo.isEditing {
//            self.constraintViewCodeHeight.constant = 0.0
//        }
//        setupFields()
//        setupStepLabel()
    }
    
    //MARK: - Actions
    @IBAction private func onButtonLocation() {
        if let screen = R.storyboard.selection.selectLocationController() {
            screen.delegate = self
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    @IBAction private func onButtonSave() {
        signUpApi()
//        if validateFields() {
           
//            self.sendPhoto {
//                if self.userInfo.isEditing {
//                    Flurry.logEvent("SignUpScreen_updateProfile")
//                    UpdateProfileRequest.fire(data: self.userInfo.userData, completion: { [weak self] (completed) in
//                        self?.unblockSelf()
//                        self?.proceedWithRegistration(success: completed)
//                    })
//                }
//                else {
//                    Flurry.logEvent("SignUpScreen_finishFreelancerSignUp")
//                    if self.userInfo.isFBSignUp {
////                        FBSignUpRequest.fire(data: self.userInfo.userData, completion: { [weak self] (completed) in
////                            self?.unblockSelf()
////                            self?.proceedWithRegistration(success: completed)
////                        })
//                        self.unblockSelf()
//                    }
//                    else {
//                        SignUpRequest.fire(data: self.userInfo.userData) { [weak self] (completed) in
//                            self?.unblockSelf()
//                            self?.proceedWithRegistration(success: completed)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    
//MARK:- SIGN UP API
    
  func signUpApi(){
        
        if Reachability.isConnectedToNetwork(){
            self.blockSelf()
            let imgUrlpic = UserDefaults.standard.value(forKey: "img") as? String ?? ""
            print(imgUrlpic)
            let username = UserDefaults.standard.value(forKey: "username") as? String ?? ""
            print(username)
            let email = UserDefaults.standard.value(forKey: "email") as? String ?? ""
            print(email)
            let password = UserDefaults.standard.value(forKey: "password") as? String ?? ""
            print(password)
            let firstName = UserDefaults.standard.value(forKey: "firstName") as? String ?? ""
            print(firstName)
            let lastName = UserDefaults.standard.value(forKey: "lastName") as? String ?? ""
            print(lastName)
            let dob = UserDefaults.standard.value(forKey: "date") as? String ?? ""
            print(dob)
            let ethnicity = UserDefaults.standard.value(forKey: "ethnicity") as? String ?? ""
            print(ethnicity)
            let category = UserDefaults.standard.value(forKey: "category") as? String ?? ""
            print(category)
            let count = UserDefaults.standard.value(forKey: "follow") as! Int
            print(count)
            let gender = UserDefaults.standard.value(forKey: "gender") as! Int
            print(gender)
            let para: [String:Any] = ["username":username,
                                      "email": email,
                                      "password":password,
                                      "isCustomer":1,
                                      "avatarMediaId":imgUrlpic,
                                      "firstName":firstName,
                                      "lastName":lastName,
                                      "birthDate":dob,
                                      "gender":gender,
                                      "ethnicityId":ethnicity,
                                      "categoryId" :category,
                                      "longitude":"77.6808",
                                      "latitude":"30.7369",
                                      "address":fieldAddress.text!,
                                      "about":"BMW owner",
                                      "followers":count,
                                      "profile_picture": imgUrlpic]
            print("para",para)
            Alamofire.request(Constants.Api.urlWithMethod(.accounts), method: .post, parameters: para).responseJSON{ [self]
                response in
                
                switch(response.result){
                
                case .success(let json):do{
                    print("json")
                    print("imagepic",imgUrlpic)
                    print(imgUrlpic)
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
                    self.unblockSelf()
                    if success == 200{
                        print("sucess====",respond)
                       let msg = respond.object(forKey: "message") as! String
//                        self.continueReg(mesg: msg)
                        self.unblockSelf()
                        print("counttttttttt",count)
                    }else{
                        self.unblockSelf()
                        Alerts.showCustomErrorMessage(title: "BMW", message: "Bad request", button: "OK")
                        self.view.isUserInteractionEnabled = true
                    }
                }
                
                case .failure(let error):do{
                    self.unblockSelf()
                    print("error-===",error)
                    Alerts.showCustomErrorMessage(title: "BMW", message: "Bad request", button: "OK")
                    self.view.isUserInteractionEnabled = true
                }
                
                }
            }
        }else{
            self.unblockSelf()
            Alerts.showNoConnectionErrorMessage()
        }
        
    }
    //MARK: - Private methods
    
    private func setupFields() {
        if let address = self.userInfo.userData["address"] as? String {
            fieldAddress.text = address
            fieldAddress.isFilled = true
        }
        labelCode.text = self.userInfo.verificationCode
    }
    
    private func setupStepLabel() {
        let currentStep = userInfo.isEditing ? "3" : "4"
        let stepNumberStr = NSMutableAttributedString(string: currentStep,
                                                      attributes: [
                                                        NSAttributedStringKey.foregroundColor : UIColor.lightRed,
                                                        NSAttributedStringKey.font : UIFont(name: "PingFangSC-Medium", size: 28.0)!
            ])
        var stepCount = 4
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
    
//    private func sendPhoto(withCompletion completion: @escaping ()->Void) {
//        if let photo = self.userInfo.image {
//            let parameter: [String: Any] = [
//                "file": ImageStructInfo(fileName: "image.jpg", type: "image/jpg", data: photo.toData())
//            ]
//            Flurry.logEvent("SignUpScreen_sendPhoto")
//            UploadImage(url: Constants.Api.urlWithMethod(.media), parameter: parameter as [String : AnyObject]).responseJSON { [weak self, completion] (data, error) in
//                if error != nil {
//                    print("error")
//                } else {
//                    let id: Int = data!["id"] as! Int
//                    self?.userInfo.userData["avatarMediaId"] = id
//
//                    completion()
//                }
//            }
//        }
//        else {
//            completion()
//        }
//    }
    
    private func proceedWithRegistration(success: Bool) {
        if success {
            if Defaults[.verificationCode] != nil {
                let alert = UIAlertController(title: Defaults[.verificationCode],
                                              message: "Add this code once somewhere in any of your Instagram post caption or hashtag to verify your account",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: false, completion: nil)
                }))
                self.present(alert, animated: true)
            }
            else {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func validateFields() -> Bool {
        var valid: Bool = true
        var errorMessage: String = ""
        if !fieldAddress.isFilled {
            valid = false
            errorMessage += "Location field can't be empty\n"
        }
        
        if !valid {
            Alerts.showCustomErrorMessage(title: "Error", message: errorMessage, button: "OK")
        }
        
        return valid
    }
}

extension SignUpLocationController: SelectLocationControllerDelegate {
    func didRemoveLocation() {
        
    }
    
    func didSelectLocation(_ location: LocationModel) {
//        self.userInfo.userData["address"] = location.locationName
       // self.userInfo.userData["latitude"] = location.latitude
        //self.userInfo.userData["longitude"] = location.longitude
        self.fieldAddress.text = location.locationName
        self.fieldAddress.isFilled = true
    }
}
