//
//  SelectLocationRequest.swift
//  BWM
//
//  Created by Serhii on 12/6/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class SelectLocationRequest {
    
    class func fire(locationId: Int, completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)"
            ]
            let url = Constants.Api.urlWithMethod(.locations) + "/\(locationId)" + Constants.Api.Method.select.rawValue
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<500)
                .response { response in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
                        case 200:
                            completion(true)
                        default:
                            if let data = response.data {
                                if let json = String(data: data, encoding: String.Encoding.utf8) {
                                    print(json)
                                }
                            }
                        }
                    }
            }
        }
    }
}
