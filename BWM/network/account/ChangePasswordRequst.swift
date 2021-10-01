//
//  ChangePasswordRequst.swift
//  BWM
//
//  Created by Serhii on 1/25/19.
//  Copyright © 2019 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class ChangePasswordRequest {
    
    class func fire(email: String, completion: @escaping (_ parameter: Bool) -> Void) {
        
        if Reachability.isConnectedToNetwork() == true {
            let data = ["email": email]
            Alamofire.request(Constants.Api.urlWithMethod(.passwords), method: .post, parameters: data, headers: nil)
                .validate(statusCode: 200..<500)
                .responseObject { (response: DataResponse<AuthObject>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
                        case 201:
                            completion(true)
                            
                        default:
                            var errorMessage = "Unknown error"
                            if let data = response.data {
                                do {
                                    if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                        errorMessage = ""
                                        for obj in dictionary {
                                            errorMessage += "\(obj.value)"
                                        }
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            Alerts.showCustomErrorMessage(title: "Error", message: errorMessage, button: "OK")
                            completion(false)
                        }
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
