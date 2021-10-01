//
//  ChatListRequest.swift
//  BWM
//
//  Created by Serhii on 8/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

class ChatListRequest {
    
    class func fire(completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            // Add Headers
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)",
            ]
            
            Alamofire.request("http://api.bwm.almet-systems.com/v1/conversations", method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    if (response.result.error == nil) {
                        
                        if let response = response.result.value as? [String: Any] {
                            
                        }
                        
                        completion(true)
                    } else {
                        completion(false)
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
