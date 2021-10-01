//
//  ChatEvent.swift
//  BWM
//
//  Created by Serhii on 8/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

enum MessageType: String {
    case message
}

class ChatEvent : Mappable {
    var type: MessageType!
    var messageId: Int?
    var body: String?
    var createdAt: TimeInterval = 0.0
    var isSelf: Bool?
    var isRead: Bool?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["event"]
        messageId <- map["id"]
        body <- map["body"]
        createdAt <- map["createdAt"]
        isSelf <- map["isSelf"]
        isRead <- map["isRead"]
    }
}
