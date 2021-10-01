//
//  GraphStatsRequest.swift
//  BWM
//
//  Created by obozhdi on 04/08/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults

class GraphStatsStore {
  
  static let shared = GraphStatsStore()
  var stats: [StatsObject]?
  var searchMax: Int = 0
  var messageMax: Int = 0
  var profileMax: Int = 0
}

class GraphStatsRequest {
  
  class func fire(id: String, completion: @escaping (_ parameter: [StatsObject]) -> Void) {
    if Reachability.isConnectedToNetwork() == true {
      let headers = [
        "Authorization":"Bearer \(Defaults[.token] ?? "")",
        "Content-Type":"application/json; charset=utf-8",
        ]
      
      Alamofire.request(Constants.Api.urlWithMethod(.statistics), method: .get, headers: headers)
        .validate(statusCode: 200..<300)
        .responseArray { (response: DataResponse<[StatsObject]>) in
          if let status = response.response?.statusCode {
            switch status {
            case 401:
                StartController.handleUnautorized()
            case 200:
              for stat in response.result.value! {
                if stat.search! > GraphStatsStore.shared.searchMax {
                  GraphStatsStore.shared.searchMax = stat.search!
                }
                if stat.message! > GraphStatsStore.shared.messageMax {
                  GraphStatsStore.shared.messageMax = stat.message!
                }
                if stat.profile! > GraphStatsStore.shared.profileMax {
                  GraphStatsStore.shared.profileMax = stat.profile!
                }
              }
              
              GraphStatsStore.shared.stats = response.result.value!.reversed()
              completion(response.result.value!)
            default:
              if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("GRAPHSTATSREQUEST: \(String(describing: json))")
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
