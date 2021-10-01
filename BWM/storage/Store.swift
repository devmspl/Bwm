//
//  Store.swift
//  BWM
//
//  Created by obozhdi on 04/06/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import Foundation
import UIKit

class Store {
    
    static let shared = Store()
    
    
    
    var tempMail: String?
    var tempPass: String?
    var tempName: String?
    var tempLastName: String?
    var tempBirthday: String?
    var tempFBToken: String?
    var tempType: Int?
    var tempLocation: String = ""
    var tempLat: Double?
    var tempLon: Double?
    var tempImage: Int?
    var locSet: Bool = false
    var tempPosts: [SelfPost]?
    var tappedUrl: String = ""
    var tappedLikes: String = ""
    var tappedComments: String = ""
    var tappedBody: String = ""
    
    var receivedMessagePushNotification: MessagePN?
    var deepLinkChatUserId: Int?
    var userIdFromVideo: Int?
    
    var token: String?
}
