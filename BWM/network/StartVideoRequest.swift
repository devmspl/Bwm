//
//  StartVideoRequest.swift
//  BWM
//
//  Created by Serhii on 9/18/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class StartVideoRequest {
    class func fire(completion: @escaping (_ videoLink: String?, _ userId: Int?, _ userAvatar: String?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {

            Alamofire.request(Constants.Api.urlWithMethod(.video), method: .get, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    if (response.result.error == nil) {
                        var url: String? = nil
                        var userId: Int? = nil
                        var userAvatar: String?
                        if let response = response.result.value as? [String: Any] {
                            url = response["videoUrl"] as? String
                            userId = response["accountId"] as? Int
                            if let value = response["avatarMedia"] as? [String: Any] {
                                let avMedia = AvatarMedia(JSON: value)
                                userAvatar = avMedia?.thumbs?.x300
                            }
                        }
                        
                        completion(url, userId, userAvatar)
                    } else {
                        completion(nil, nil, nil)
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
