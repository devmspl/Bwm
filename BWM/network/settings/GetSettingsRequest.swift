//
//  GetSettingsRequest.swift
//  BWM
//
//  Created by Serhii on 12/8/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults


class GetSettingsRequest {
    
    class func fire(completion: @escaping (_ parameter: Bool, _ settings: Settings?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            // Add Headers
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)",
            ]
            
            Alamofire.request(Constants.Api.urlWithMethod(.settings), method: .get, headers: headers)
                .validate(statusCode: 200..<500)
                .responseObject { (response: DataResponse<Settings>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
                        case 200:
                            
                            completion(true, response.result.value!)
                            
                        default:
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                Alerts.showCustomErrorMessage(title: "Error", message: String(describing: json), button: "Try Again")
                            }
                            
                            completion(false, nil)
                        }
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
