//
//  IPLocationRequest.swift
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

class IPLocationRequest {
    
    class func fire(completion: @escaping (_ parameter: CLLocationCoordinate2D?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            
            Alamofire.request("http://ip-api.com/json", method: .get)
                .validate(statusCode: 200..<300)
                .responseObject { (response: DataResponse<IPLocation>) in
                    if let lat = response.result.value?.lat,
                        let lon = response.result.value?.lon {
                        let coordinates = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(lon))
                        completion(coordinates)
                    }
                    else {
                        completion(nil)
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
    
}
