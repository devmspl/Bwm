//
//  FBSignUpRequest.swift
//  BWM
//
//  Created by Serhii on 9/2/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class FBSignUpRequest: BaseViewController {
    
    static let sharedInstance = FBSignUpRequest()
    
//    class func fire(data: [String: Any], completion: @escaping (_ parameter: Bool) -> Void) {
//        if Reachability.isConnectedToNetwork() == true {
//            Alamofire.request(Constants.Api.urlWithMethod(.signUpFB), method: .post, parameters: data)
//                .validate(statusCode: 200..<500)
//                .responseObject { (response: DataResponse<AuthObject>) in
//                    if let status = response.response?.statusCode {
//                        switch status {
//                        case 200:
//                            Defaults[.verificationCode] = response.result.value!.verificationCode
//                            Defaults[.token] = response.result.value!.accessToken
//                            completion(true)
//
//                        default:
//                            var errorMessage = "Unknown error"
//                            if let data = response.data {
//                                do {
//                                    if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                                        errorMessage = ""
//                                        for obj in dictionary {
//                                            errorMessage += "\(obj.value)"
//                                        }
//                                    }
//                                } catch {
//                                    print(error.localizedDescription)
//                                }
//                            }
//
//                            Alerts.showCustomErrorMessage(title: "Error", message: errorMessage, button: "OK")
//                            completion(false)
//                        }
//                    }
//            }
//        } else {
//            Alerts.showNoConnectionErrorMessage()
//        }
//    }
   //MARK:- FACEBOOK LOGIN
    func fbSocialLogin(username:String,email:String,isCustomer:String,avatarMediaId:String,firstName:String,lastName:String,birthDate:String,gender:String,facebook_id:String){
        if Reachability.isConnectedToNetwork(){
            self.blockSelf()
            let para : [String:Any] = ["username":username,"email":email,"isCustomer":isCustomer,"avatarMediaId":avatarMediaId,"firstName":firstName,"lastName":lastName,"birthDate":birthDate,"gender":gender,"facebook_id":facebook_id]
            print("params",para)
            Alamofire.request(Constants.Api.urlWithMethod(.signUpFB),method: .post,parameters: para,encoding: JSONEncoding.default).responseJSON{
                response in
                switch(response.result){
                
                case .success(let json):do{
                    self.unblockSelf()
                    print(json)
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
                    if success == 200{
                        self.unblockSelf()
                        print("successss==",respond)
                        let alert = UIAlertController.init(title: "BWM", message: "Login Successful", preferredStyle: .alert)
                                        let ok = UIAlertAction.init(title: "Ok", style: .default) { (ok) in
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! MainTabbarController
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                        alert.addAction(ok)
                                        self.present(alert, animated: true, completion: nil)
                        self.view.isUserInteractionEnabled = true
                    }else{
                        self.unblockSelf()
                        self.view.isUserInteractionEnabled = true
                    }
                }
                    
                case .failure(let error):do{
                    print("error",error)
                    self.unblockSelf()
                    self.view.isUserInteractionEnabled = true
                }
                
                }
            }
        }else{
            self.unblockSelf()
            Alerts.showNoConnectionErrorMessage()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    
}
