//
//  GetSelfTokensRequest.swift
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

class TokensStore {
  
  static var shared = TokensStore()
  
  var tokens: Int?
  
}

class GetSelfTokensRequest {
  
  class func fire(completion: @escaping (_ parameter: Bool) -> Void) {
    if Reachability.isConnectedToNetwork() == true {
      // Add Headers
      let headers = [
        "Authorization":"Bearer \(Defaults[.token]!)",
      ]
      
      Alamofire.request(Constants.Api.urlWithMethod(.balance), method: .get, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          if (response.result.error == nil) {
            
            if let response = response.result.value as? [String: Any] {
              if let tokens = response["tokens"] {
                TokensStore.shared.tokens = (tokens as! Int)
              }
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

