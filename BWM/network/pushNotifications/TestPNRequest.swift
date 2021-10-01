//
//  TestPNRequest.swift
//  BWM
//
//  Created by Serhii on 10/17/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class TestPNRequest {
    
    class func fire() {
        if Reachability.isConnectedToNetwork() == true {
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)"
            ]
            Alamofire.request("http://74.208.252.135/v1/pns/test", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            print("TEST PN SENT")
                        default:
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
