//
//  EthnicitiesRequest.swift
//  BWM
//
//  Created by Serhii on 8/28/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import SwiftyUserDefaults

class EthnicitiesRequest {
    
    class func fire(completion: @escaping (_ parameter: Bool, _ conversations: [Ethnicity]?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            Alamofire.request(Constants.Api.urlWithMethod(.ethnicities), method: .get, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    if (response.result.error == nil) {
                        var ethnicities: [Ethnicity] = []
                        
                        if let response = response.result.value as? [[String: Any]] {
                            for item in response {
                                if let ethnicity = Ethnicity(JSON: item) {
                                    ethnicities.append(ethnicity)
                                }
                            }
                        }
                        EthnicityStorage.shared.ethnicities = ethnicities
                        completion(true, ethnicities)
                    } else {
                        completion(false, nil)
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
