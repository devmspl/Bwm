//
//  CheckInstAccRequest.swift
//  BWM
//
//  Created by Serhii on 3/14/19.
//  Copyright © 2019 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class CheckInstAccRequest {
    
    class func fire(username: String, completion: @escaping (_ parameter: Bool, _ errorMsg: String?) -> Void) {
        
        if Reachability.isConnectedToNetwork() == true {
            let data = ["username": username]
            Alamofire.request(Constants.Api.urlWithMethod(.checkInstagram), method: .post, parameters: data)
                .validate(statusCode: 200..<500)
                .responseJSON { (response) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 201:
                            completion(true, nil)
                        case 404, 401:
                            if let response = response.result.value as? [String: String],
                                let msg = response["message"]{
                                completion(false, msg)
                            }
                            else {
                                completion(false, nil)
                            }
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
                            completion(false, errorMessage)
                        }
                    }
            }
        }
        else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
