//
//  IncreaseBalanceRequest.swift
//  BWM
//
//  Created by Serhii on 9/1/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire
import ObjectMapper

class IncreaseBalanceRequest {
    
    class func fire(tokenCount: Int, completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)"
                ]
            
            let body = ["sum": tokenCount]
            
             Alamofire.request(Constants.Api.urlWithMethod(.balance), method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
                        case 201:
                            /*if let response = response.result.value as? [String: Any] {
                                if let tokens = response["sum"] {
                                    print(tokens)
                                    TokensStore.shared.tokens = (tokens as! Int)
                                }
                            }*/
                            
                            completion(true)
                        default:
                            completion(false)
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("IncreaseBalanceRequest: \(String(describing: json))")
                                Alerts.showCustomErrorMessage(title: "Error", message: String(describing: json), button: "OK")
                            }
                        }
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
