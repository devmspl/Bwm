//
//  UpdatePasswordRequest.swift
//  BWM
//
//  Created by Serhii on 1/19/19.
//  Copyright © 2019 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class UpdatePasswordRequest {
    
    class func fire(newPassword: String, completion: @escaping (_ parameter: Bool) -> Void) {
        
        let headers = [
            "Authorization":"Bearer \(Defaults[.token]!)"
        ]
        
        if Reachability.isConnectedToNetwork() == true {
            let data = ["password": newPassword]
            Alamofire.request(Constants.Api.urlWithMethod(.updatePassword), method: .post, parameters: data, headers: headers)
                .validate(statusCode: 200..<500)
                .responseObject { (response: DataResponse<AuthObject>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
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
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
