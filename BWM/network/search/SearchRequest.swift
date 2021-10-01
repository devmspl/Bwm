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
import CoreLocation

class SearchStore {
    
    static let shared = SearchStore()
    
    lazy var filterObject: SearchRequestObject = {
        return SearchRequestObject(withCoordinates: LocationManager.shared.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    }()
}
//MARK:- SEARCH REQUEST
class SearchRequest {
    
    class func fire(data: [String: Any], completion: @escaping (_ parameter: [SearchObject]) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            
            let headers = [
                "Authorization":"Bearer \(Defaults[.token] ?? "")"
            ]
            
            let body = data
            Alamofire.request(Constants.Api.urlWithMethod(.searches), method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<500)
                .responseArray { (response: DataResponse<[SearchObject]>) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 401:
                            StartController.handleUnautorized()
                        case 200:
                            if var users = response.result.value {
                                users.sort(by: { (obj1, obj2) -> Bool in
                                    return obj1.position > obj2.position
                                })
                                
                                completion(response.result.value!)
                            }
                        default:
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("SEARCHREQUEST: \(String(describing: json))")
//                                Alerts.showCustomErrorMessage(title: "Error", message: String(describing: json), button: "OK")
                            }
                        }
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
