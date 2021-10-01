//
//  UploadReceiptRequest.swift
//  BWM
//
//  Created by Serhii on 9/6/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class UploadReceiptRequest {
    
    class func fire(isSubscription: Bool, data: Data, completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)"
            ]
            
            let body = ["receiptBase64": data.base64EncodedString()]
            let method: Constants.Api.Method = isSubscription ? .subscription : .balance
            Alamofire.request(Constants.Api.urlWithMethod(method), method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<500)
                .responseArray { (response: DataResponse<[SearchObject]>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
                        case 201:
                            
                            completion(true)
                        default:
                            if let data = response.data {
                                if let json = String(data: data, encoding: String.Encoding.utf8) {
                                    print(json)
                                }
                            }
                            completion(false)
                        }
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
