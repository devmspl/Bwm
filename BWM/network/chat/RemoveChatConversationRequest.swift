//
//  RemoveChatConversationRequest.swift
//  BWM
//
//  Created by Serhii on 8/26/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire

class RemoveChatConversationRequest {
    
    class func fire(withUserId userId: Int, completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            // Add Headers
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)",
            ]
            
            Alamofire.request(Constants.Api.urlWithMethod(.chat) + "/\(userId)", method: .delete, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    if (response.result.error == nil) {
                        
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
