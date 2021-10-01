//
//  GetLastMessagesRequest.swift
//  BWM
//
//  Created by Serhii on 8/24/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class GetLastMessagesRequest {
    
    class func fire(forUserId uId: Int, onPage page: Int, itemsCount: Int, completion: @escaping (_ parameter: Bool, _ messages: [ChatEvent]?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            // Add Headers
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)",
            ]
            
            Alamofire.request(Constants.Api.baseUrl + "/conversations/\(uId)/messages?page=\(page)&per-page=\(itemsCount)", method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    if (response.result.error == nil) {
                        
                        var messages = [ChatEvent]()
                        if let response = response.result.value as? [[String: Any]] {
                            for item in response {
                                if let message = ChatEvent(JSON: item) {
                                    messages.append(message)
                                }
                            }
                        }
                        
                        completion(true, messages)
                    } else {
                        completion(false, nil)
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
