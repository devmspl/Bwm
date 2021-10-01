//
//  RegisterPushTokenRequest.swift
//  BWM
//
//  Created by Serhii on 9/7/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class RegisterPushTokenRequest {
    
    class func fire(token: String, completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            
            let headers = [
                "Authorization":"Bearer \(Defaults[.token] ?? "")"
            ]
            
            let body = ["deviceToken": token]
            
            Alamofire.request(Constants.Api.urlWithMethod(.pnToken), method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<500)
                .responseJSON(completionHandler: { (response) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            
                            completion(true)
                        default:
                            if let data = response.data {
                                if let json = String(data: data, encoding: String.Encoding.utf8) { print(json) }
                                completion(false)
                            }
                        }
                    }
                })
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
