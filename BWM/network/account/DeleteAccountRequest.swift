//
//  DeleteAccountRequest.swift
//  BWM
//
//  Created by Serhii on 10/26/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class DeleteAccountRequest {
    
    class func fire(completion: @escaping (_ parameter: Bool) -> Void) {
        
        let headers = [
            "Authorization":"Bearer \(Defaults[.token]!)"
        ]
        
        if Reachability.isConnectedToNetwork() == true {
            Alamofire.request(Constants.Api.urlWithMethod(.deleteAccount), method: .delete, parameters: nil, headers: headers)
                .validate(statusCode: 200..<500)
                .response(completionHandler: { (response) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
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
                })
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
