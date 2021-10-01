//
//  MoveToTopRequest.swift
//  BWM
//
//  Created by Serhii on 9/1/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire
import ObjectMapper

class MoveToTopRequest {
    
    class func fire(completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)"
            ]
            
            Alamofire.request(Constants.Api.urlWithMethod(.profileMoveTop), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
                        case 201:
                            completion(true)
                        default:
                            completion(false)
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("MoveToTopRequest: \(String(describing: json))")
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
