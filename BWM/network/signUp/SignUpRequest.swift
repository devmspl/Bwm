//
//  SignUpRequest.swift
//  BWM
//
//  Created by obozhdi on 04/06/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class SignUpRequest {
    
    class func fire(data: [String: Any], completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            Alamofire.request(Constants.Api.urlWithMethod(.accounts), method: .post, parameters: data)
                .validate(statusCode: 199..<500)
                .responseObject { (response: DataResponse<AuthObject>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            Defaults[.verificationCode] = response.result.value!.verificationCode
                            Defaults[.token] = response.result.value!.accessToken
                            completion(true)
                            
                        default:
                            var errorMessage = "Unknown error"
                            if let data = response.data {
                                do {
                                    if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                        errorMessage = "hello"
                                        for obj in dictionary {
                                            errorMessage += "\(obj.value)"
                                            print(Constants.Api.urlWithMethod(.accounts))
                                        }
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                    print(Constants.Api.urlWithMethod(.accounts))
                                }
                            }
                            
                            Alerts.showCustomErrorMessage(title: "Error", message: errorMessage, button: "OK")
                            print("helo\(Constants.Api.urlWithMethod(.accounts))")
                            completion(false)
                        }
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
