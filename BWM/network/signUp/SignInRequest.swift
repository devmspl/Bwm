//
//  SignInRequest.swift
//  BWM
//
//  Created by obozhdi on 04/06/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class SignInRequest: BaseViewController {
    
    class func fire(login: String, password: String, completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            let body: [String : Any] = ["email": login,
                                        "password": password]
            print("para",body)
            Alamofire.request(Constants.Api.urlWithMethod(.login), method: .post, parameters: body,encoding: JSONEncoding.default).responseJSON{
                response in
                
                switch response.result {
                case .success(let json):do{
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
                    if success == 200{
                        let succ = respond.object(forKey: "status") as! String
                        if succ == "1"{
                            print("success==",respond)
                            Defaults[.token] = respond.object(forKey: "remember_token") as? String ?? ""
                            let lat = respond.object(forKey: "latitude") as? String ?? "30.7369"
                            let long = respond.object(forKey: "longitude") as? String ?? "77.6808"
                            UserDefaults.standard.setValue(lat, forKey: "lat")
                            UserDefaults.standard.setValue(long, forKey: "long")
                            let abc = respond.object(forKey: "username") as! String
                            UserDefaults.standard.setValue(abc, forKey: "username")
                            print("tokennnnn..\(Defaults[.token] ?? "")")
                        
                            completion(true)
                        }
                        else{
                            //unblockSelf()
                            completion(false)
                            let msg = respond.object(forKey: "message") as! String
                            Alerts.showCustomErrorMessage(title: "BWM", message: msg , button: "OK")
                        }
                     
                    }else{
                        completion(false)
                        let message = respond.object(forKey: "message") as? String
                        Alerts.showCustomErrorMessage(title: "BWM", message:message!, button: "OK")
                    }
           
                   
                }
                    
                case .failure(let error):do{
                    print("error",error)
                    completion(false)
                    
                }
//                    if let data = response.data {
//                        let json = String(data: data, encoding: String.Encoding.utf8)
//                        print("FAIL SIGNIN: \(String(describing: json))")
//                    }
//                    Alerts.showCustomErrorMessage(title: "Error", message: "Email or password is wrong", button: "Try Again")
//                    completion(false)
                }
                    
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}

class FBSignInRequest {
    
    class func fire(accessToken: String, completion: @escaping (_ parameter: Bool, _ errorMsg: String?, _ errorCode: Int?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            let body: [String : Any] = ["facebookAccessToken": accessToken]
            
            Alamofire.request(Constants.Api.urlWithMethod(.signInFB), method: .post, parameters: body)
                .validate(statusCode: 200..<500)
                .responseObject { (response: DataResponse<AuthObject>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            Defaults[.token] = response.result.value!.accessToken
                            
                            if response.result.value?.isCustomer == true {
                                Defaults[.userType] = "customer"
                            } else {
                                Defaults[.userType] = "freelancer"
                            }
                            Defaults[.verificationCode] = response.result.value!.verificationCode
                            
                            completion(true, nil, nil)
                            
                        default:
                            if let data = response.data,
                                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any],
                                let msg = json?["facebookAccessToken"] as? String {
                                completion(false, msg, status)
                            }
                            else {
                                completion(false, "Unknown error", status)
                            }
                        }
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
