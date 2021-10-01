//
//  SignUpNameController.swift
//  BWM
//
//  Created by Serhii on 10/16/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
//import ImagePicker
import Permission
import YPImagePicker
import Flurry_iOS_SDK
import Alamofire

class SignUpNameController: BaseViewController {

    @IBOutlet private weak var fieldFirst: BWMTextField!
    @IBOutlet private weak var fieldLast: BWMTextField!
    @IBOutlet private weak var fieldUserName: BWMTextField!
    
    @IBOutlet private weak var labelStep: UILabel!
    @IBOutlet private weak var labelScreenTitle: UILabel!
    @IBOutlet private weak var buttonNext: UIButton!
    
    @IBOutlet fileprivate weak var imageAvatar: UIImageView!
    
    @IBOutlet private weak var labelTerms: UILabel!
    
    var userInfo: UserSetupModel!
    var arry = [AnyObject]()
    var msg = ""
    var email = ""
    var isCustomer = ""
    var password = ""
    let instaUrl = "https://www.instagram.com/web/search/topsearch/?context=user&count=0&query="
    let instaFollow = "https://www.instagram.com/"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addInputVisibilityController()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTermsTap))
        labelTerms.addGestureRecognizer(tapGesture)
        
        labelScreenTitle.text = userInfo.isEditing ? "Edit account" : "New Account"
        
        if userInfo.isEditing || userInfo.isFBSignUp {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(onCloseButton))
        }
        
        Flurry.logEvent("SignUpScreen_nameInput")
        
        setupStepLabel()
        setupFields()
    }
    
    //MARK: - Actions
    
    @objc private func onCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func onNextButton() {
        self.userInfo.userData["firstName"] = fieldFirst.text
        self.userInfo.userData["lastName"] = fieldLast.text
        self.userInfo.userData["username"] = fieldUserName.text
        self.userInfo.userData["isCustomer"] = 1
//SignupAPi()
        
        
        if isCustomer == "0"{
            checkInsta()
//            SignupAPi()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpProfileController") as! SignUpProfileController
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        if validateFields() {
//            blockSelf()
//            SignUpRequest.fire(data: self.userInfo.userData) { [weak self] (completed) in
//                self?.unblockSelf()
//                self?.proceedWithRegistration(success: completed)
//            }
//
//        }
    }
// MARK:- CHECK INSTA
    func checkInsta(){
        if Reachability.isConnectedToNetwork(){

            Alamofire.request(instaUrl+fieldUserName.text!,method: .get,encoding:  JSONEncoding.default).responseJSON{
                response in
                switch(response.result){

                case .success(let json):do{
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
                    var abc = ""
                    if success == 200{
                        print("not found",respond)
                        let user = respond.object(forKey: "users") as! [AnyObject]
                        if user.count != 0{
                            for i in 0...user.count-1{
                                let userr = user[i]["user"] as! NSDictionary
                                let username = userr.object(forKey: "username") as! String
                                print("helloooo",username)
                                if self.fieldUserName.text == username{
                                    self.getFollower()
                                    print("userfound===")
                                    abc = username
                                }
                            }
                            
                            if abc == ""{
                                Alerts.showCustomErrorMessage(title: "BWM", message: "Instagram account not found", button: "ok")
                            }else{
                                self.view.isUserInteractionEnabled = true
                            }
                        }else{
                            Alerts.showCustomErrorMessage(title: "BWM", message: "Instagram account not found", button: "ok")
                        }
                        
                    }
                }

                case .failure(let error):do{
                    print(error)
                }
                }
            }
        }
    }
    
//MARK:- GET FOLLOWER
    func getFollower(){
        if Reachability.isConnectedToNetwork(){

            Alamofire.request(instaFollow+fieldUserName.text!+"?__a=1",method: .get,encoding:  JSONEncoding.default).responseJSON{[self]
                response in
                switch(response.result){

                case .success(let json):do{
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
//                    var abc = ""
                    if success == 200{
                        print("found",respond)
                        let graph = respond.object(forKey: "graphql") as! NSDictionary
                        let user = graph.object(forKey: "user") as! NSDictionary
                        let follow = user.object(forKey: "edge_followed_by") as! NSDictionary
                        let count = follow.object(forKey: "count") as! Int
                        print("countttt===",count)
                        SignupAPi()
                    }else{
                        self.view.isUserInteractionEnabled = true
                    }
                }

                case .failure(let error):do{
                    print(error)
                    self.view.isUserInteractionEnabled = true
                }
                }
            }
        }else{
            Alerts.showNoConnectionErrorMessage()
        }
    }
//MARK:- SIGNUPAPI
    func SignupAPi(){
        
        if Reachability.isConnectedToNetwork(){
            self.blockSelf()
            let para: [String:Any] = ["username":fieldUserName.text!,
                                      "email": email,
                                      "password":password,
                                      "isCustomer":isCustomer,
                                      "avatarMediaId":"123",
                                      "firstName":fieldFirst.text!,
                                      "lastName":fieldLast.text!,
                                      "birthDate":"12/10/2021",
                                      "gender":"0",
                                      "ethnicityId":"2312341",
                                      "categoryId" :"gewrger",
                                      "longitude":"12312.334234.35",
                                      "latitude":"65.7676756.567567.657",
                                      "address":"abc Street",
                                      "about":"BMW owner"]
            print("para",para)
            Alamofire.request(Constants.Api.urlWithMethod(.accounts), method: .post, parameters: para).responseJSON{ [self]
                response in
                
                switch(response.result){
                
                case .success(let json):do{
                    print("json")
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
                    self.blockSelf()
                    if success == 200{
                        print("sucess====",respond)
                        msg = respond.object(forKey: "message") as! String
                        self.continueReg(mesg: msg)
                        self.unblockSelf()
                    }else{
                        self.blockSelf()
                        Alerts.showCustomErrorMessage(title: "BMW", message: "Bad request", button: "OK")
                        self.view.isUserInteractionEnabled = true
                    }
                }
                
                case .failure(let error):do{
                    print("error-===",error)
                    Alerts.showCustomErrorMessage(title: "BMW", message: "Bad request", button: "OK")
                    self.view.isUserInteractionEnabled = true
                }
                
                }
            }
        }else{
            Alerts.showNoConnectionErrorMessage()
        }
        
    }
//MARK:- ON PHOTO BUTTON
    
    @IBAction private func onPhotoButton() {
        let permission: Permission = .photos
        
        permission.request { status in
            switch status {
            case .authorized:
                var config = YPImagePickerConfiguration()
                config.usesFrontCamera = true
                config.showsFilters = false
                config.showsCrop = .rectangle(ratio: 1.0)
                config.shouldSaveNewPicturesToAlbum = false
                config.screens = [.library, .photo]
                let picker = YPImagePicker(configuration: config)
                
                picker.didFinishPicking { [unowned picker] items, _ in
                    if let photo = items.singlePhoto {
                        let image = photo.image
                        
                        self.imageAvatar.image = image
                        self.imageAvatar.contentMode = .scaleAspectFill
                        self.userInfo.image = image
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                self.present(picker, animated: true, completion: nil)
            case .denied:        print("denied")
            case .disabled:      print("disabled")
            case .notDetermined: print("not determined")
            }
        }
    }
    
    @objc private func onTermsTap() {
        print("tap")
    }
    
    //MARK: - Private methods
    private func continueReg(mesg: String){
            let alert = UIAlertController.init(title: "BWM", message: mesg, preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .default) { (ok) in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninController") as! SigninController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
    }
    
    private func continueRegistration() {
        self.userInfo.userData["firstName"] = fieldFirst.text
        self.userInfo.userData["lastName"] = fieldLast.text
        self.userInfo.userData["username"] = fieldUserName.text
        
        if self.userInfo.isCustomer {
            self.blockSelf()
            self.userInfo.userData["isCustomer"] = 1
            self.sendPhoto {
                if self.userInfo.isEditing {
                    print("hello photo")
                    Flurry.logEvent("SignUpScreen_updateProfile")
                    UpdateProfileRequest.fire(data: self.userInfo.userData, completion: { [weak self] (completed) in
                        self?.unblockSelf()
                        self?.proceedWithRegistration(success: completed)
                    })
                }
                else {
                    Flurry.logEvent("SignUpScreen_finishCustomerSignUp")
                    if self.userInfo.isFBSignUp {
                        print("fb")
//                        FBSignUpRequest.fire(data: self.userInfo.userData, completion: { [weak self] (completed) in
//                            self?.unblockSelf()
//                            self?.proceedWithRegistration(success: completed)
//                        })
                        self.unblockSelf()
                    }
                    else {
                        SignUpRequest.fire(data: self.userInfo.userData) { [weak self] (completed) in
                            self?.unblockSelf()
                            self?.proceedWithRegistration(success: completed)
                        }
                    }
                }
            }
        }
        else {
            self.performSegue(withIdentifier: R.segue.signUpNameController.signUpStep3.identifier, sender: self)
        }
    }
    
    private func setupStepLabel() {
        if userInfo.isEditing && userInfo.isCustomer {
            self.labelStep.isHidden = true
        }
        else {
            let currentStep = userInfo.isEditing ? "1" : "2"
            let stepNumberStr = NSMutableAttributedString(string: currentStep,
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
    }
    
    private func sendPhoto(withCompletion completion: @escaping ()->Void) {
        if let photo = self.userInfo.image {
            let parameter: [String: Any] = [
                "file": ImageStructInfo(fileName: "image.jpg", type: "image/jpg", data: photo.toData())
            ]
            Flurry.logEvent("SignUpScreen_sendPhoto")
            UploadImage(url: Constants.Api.urlWithMethod(.media), parameter: parameter as [String : AnyObject]).responseJSON { [weak self, completion] (data, error) in
                if error != nil {
                    print("error")
                } else {
                    let id: Int = data!["id"] as! Int
                    self?.userInfo.userData["avatarMediaId"] = id
                    
                    completion()
                }
            }
        }
        else {
            completion()
        }
    }
    
    private func proceedWithRegistration(success: Bool) {
        if success {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupFields() {
        if let text = userInfo.userData["username"] as? String {
            self.fieldUserName.text = text
            self.fieldUserName.isFilled = true
        }
        if let first = (userInfo.userData["firstName"] as? String),
            let last = (userInfo.userData["lastName"] as? String) {
            self.fieldFirst.text = first
            self.fieldLast.text = last
            
            self.fieldFirst.isFilled = true
            self.fieldLast.isFilled = true
        }
        
        if userInfo.isCustomer {
            self.buttonNext.setTitle("Save", for: .normal)
        }
    }
    
    private func validateFields() -> Bool {
        var valid: Bool = true
        var errorMessage: String = ""
        if !fieldFirst.isFilled {
            valid = false
            errorMessage += "First name is incorrect\n"
        }
        
        if !fieldLast.isFilled {
            valid = false
            errorMessage += "Last name is incorrect\n"
        }
        
        if !fieldUserName.isFilled {
            valid = false
            errorMessage += "Instagram user name is incorrect"
        }
        
        if !valid {
            Alerts.showCustomErrorMessage(title: "Error", message: errorMessage, button: "OK")
        }
        
        return valid
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let screen = segue.destination as? SignUpProfileController {
            screen.userInfo = self.userInfo
        }
    }

}
