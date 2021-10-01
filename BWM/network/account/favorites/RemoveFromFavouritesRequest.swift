//
//  RemoveFromFavouritesRequest.swift
//  BWM
//
//  Created by obozhdi on 22/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire
import ObjectMapper

class RemoveFromFavouritesRequest {
  
  class func fire(id: Int, completion: @escaping (_ parameter: Bool) -> Void) {
    if Reachability.isConnectedToNetwork() == true {
      let headers = [
        "Authorization":"Bearer \(Defaults[.token]!)",
        "Content-Type":"application/json; charset=utf-8",
        ]
      
      let body: [String : Any] = [:]
      
      Alamofire.request(Constants.Api.urlWithMethod(.favorites) + "/\(id)", method: .delete, parameters: body, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          if let status = response.response?.statusCode {
            switch status {
            case 204:
              completion(true)
            default:
              completion(false)
              if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("REMOVEFROMFAVREQUEST: \(String(describing: json))")
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
