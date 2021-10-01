//
//  SearchRequest.swift
//  BWM
//
//  Created by obozhdi on 16/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class AlienPhotosRequest {
    
    class func fire(id: String, completion: @escaping (_ parameter: [AlienPhotos]) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)",
                "Content-Type":"application/json; charset=utf-8",
                ]
            
            Alamofire.request(Constants.Api.getPostUrl(forId: id), method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseArray { (response: DataResponse<[AlienPhotos]>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            completion(response.result.value!)
                        default:
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("AlienPhotosRequest: \(String(describing: json))")
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
