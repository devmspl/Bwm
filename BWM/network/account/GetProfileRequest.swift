//
//  GetProfileRequest.swift
//  BWM
//
//  Created by obozhdi on 22/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults


class GetProfileRequest {
  
    class func fire(completion: @escaping (_ parameter: Bool, _ user: AuthObject?) -> Void) {
    if Reachability.isConnectedToNetwork() == true {
      // Add Headers
      let headers = [
        "Authorization":"Bearer \(Defaults[.token] ?? "")",
        ]
      
      Alamofire.request(Constants.Api.urlWithMethod(.profile), method: .get, headers: headers)
        .validate(statusCode: 200..<500)
        .responseObject { (response: DataResponse<AuthObject>) in
          if let status = response.response?.statusCode {
            switch status {
            case 401:
                StartController.handleUnautorized()
            case 200:
              print(response.result.value!.accessToken)
              Defaults[.token] = response.result.value!.accessToken
              
              if response.result.value?.isCustomer == true {
                Defaults[.userType] = "customer"
              } else {
                Defaults[.userType] = "freelancer"
              }
              
              completion(true, response.result.value!)
              
            default:
              if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("GETPROFILEREQUEST: \(String(describing: json))")
//                Alerts.showCustomErrorMessage(title: "Error", message: String(describing: json), button: "Try Again")
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
