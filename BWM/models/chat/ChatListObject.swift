//
//  ChatListObject.swift
//  BWM
//
//  Created by Serhii on 8/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ChatListObject: Mappable {
    
    var account: AuthObject!
    var createdAt: TimeInterval = 0.0
    var updatedAt: TimeInterval = 0.0
    var latestMessage: ChatEvent?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        account <- map["conversationAccount"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        latestMessage <- map["latestMessage"]
    }
    
    
}
