//
//  MessagePN.swift
//  BWM
//
//  Created by Serhii on 9/7/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class MessagePN: Mappable {

    var type: String?
    var title: String?
    var message: String?
    var accountId: Int?
    var userName: String?
    var fullName: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        title <- map["title"]
        message <- map["message"]
        accountId <- map["accountId"]
        userName <- map["username"]
        fullName <- map["fullName"]
    }
    
    
}
