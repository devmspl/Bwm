//
//  CategoriesRequest.swift
//  BWM
//
//  Created by Serhii on 8/28/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyUserDefaults

class CategoryRequest {
    
    class func fire(completion: @escaping (_ parameter: Bool, _ conversations: [Category]?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            Alamofire.request(Constants.Api.urlWithMethod(.categories), method: .get, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    if (response.result.error == nil) {
                        var categories: [Category] = []
                        
                        if let response = response.result.value as? [[String: Any]] {
                            for item in response {
                                if let category = Category(JSON: item) {
                                    categories.append(category)
                                }
                            }
                        }
                        
                        CategoryStorage.shared.categories = categories
                        
                        completion(true, categories)
                    } else {
                        completion(false, nil)
                    }
            }
        } else {
            Alerts.showNoConnectionErrorMessage()
        }
    }
}
