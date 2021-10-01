//
//  FavouritesRequest.swift
//  BWM
//
//  Created by obozhdi on 20/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

//TODO: REMOVE THIS
class FavouritesStore {
  
  static let shared = FavouritesStore()
  
  var users: [FavouritesObject] = []
}

class FavouritesRequest: BaseViewController {
  
  class func fire(completion: @escaping (_ parameter: Bool) -> Void) {
    if Reachability.isConnectedToNetwork() == true {
      let headers = [
        "Authorization":"Bearer \(Defaults[.token]!)",
        "Content-Type":"application/json; charset=utf-8",
        ]
      
      Alamofire.request(Constants.Api.urlWithMethod(.favorites), method: .get, headers: headers)
        .validate(statusCode: 200..<300)
        .responseArray { (response: DataResponse<[FavouritesObject]>) in
          if let status = response.response?.statusCode {
            switch status {
            case 200:
              FavouritesStore.shared.users = response.result.value!
              completion(true)
            default:
              if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("FAVOURITESREQUEST: \(String(describing: json))")
//                Alerts.showCustomErrorMessage(title: "Error", message: String(describing: json), button: "OK")
              }
              
            }
          }
      }
    } else {
      Alerts.showNoConnectionErrorMessage()
    }
  }
  
}

