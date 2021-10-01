//
//  UpdateLocationRequest.swift
//  BWM
//
//  Created by Serhii on 9/16/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults
import CoreLocation

class UpdateLocationRequest {
    
    class func fire(coords: CLLocationCoordinate2D, completion: @escaping (_ parameter: Bool) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            
            let headers = [
                "Authorization":"Bearer \(Defaults[.token]!)"
            ]
            let body = [
                "longitude": coords.longitude,
                "latitude" : coords.latitude
            ]
            Alamofire.request(Constants.Api.urlWithMethod(.currentLocation), method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers)
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
