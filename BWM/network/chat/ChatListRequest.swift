//
//  ChatListRequest.swift
//  BWM
//
//  Created by Serhii on 8/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class ChatListRequest {
    
    class func fire(completion: @escaping (_ parameter: Bool, _ conversations: [ChatListObject]?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            // Add Headers
            let headers = [
                "Authorization":"Bearer \(Defaults[.token] ?? "")",
            ]
            
            Alamofire.request(Constants.Api.urlWithMethod(.chat), method: .get, headers: headers)
                .validate(statusCode: 200..<500)
                .responseJSON { (response) in
                    if response.response?.statusCode == 401 {
                        StartController.handleUnautorized()
                        return
                    }
                    if (response.result.error == nil) {
                        
                        var conversations = [ChatListObject]()
                        
                        if let response = response.result.value as? [[String: Any]] {
                            for item in response {
                                if let conversation = ChatListObject(JSON: item) {
                                    conversations.append(conversation)
                                }
                            }
                        }
                        
                        conversations.sort(by: { (chat1, chat2) -> Bool in
                            let chat1Date = chat1.latestMessage?.createdAt ?? 0.0
                            let chat2Date = chat2.latestMessage?.createdAt ?? 0.0
                            return chat1Date > chat2Date
                        })
                        
                        completion(true, conversations)
                    } else {
                        completion(false, nil)
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
