//
//  ReportAccountRequest.swift
//  BWM
//
//  Created by Serhii on 4/30/19.
//  Copyright © 2019 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class ReportAccountRequest {
    
    class func fire(userId: String, completion: @escaping (_ parameter: Bool, _ errorMsg: String?) -> Void) {
        let url = Constants.Api.urlWithMethod(.reportAccount)+"\(userId)"
        
        let headers = [
            "Authorization":"Bearer \(Defaults[.token]!)",
            "Content-Type":"application/json; charset=utf-8",
            ]
        
        if Reachability.isConnectedToNetwork() == true {
            Alamofire.request(url, method: .post, parameters: nil, headers: headers)
            //Alamofire.request(url, method: .post, parameters: nil)
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
