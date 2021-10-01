//
//  Constants.swift
//  BWM
//
//  Created by Serhii on 11/4/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let onboarding = DefaultsKey<Bool?>("onboarding")
    static let token = DefaultsKey<String?>("token")
    static let pnToken = DefaultsKey<String?>("pnToken")
    static let userType = DefaultsKey<String?>("userType")
    static let verificationCode = DefaultsKey<String?>("verificationCode")
    static let userIsPro = DefaultsKey<Bool?>("userIsPro")
    static let liveTracking = DefaultsKey<Bool?>("liveTracking")
}

struct Constants {
    struct Key {
        static let messageCount = "messageCount"
        static let accountId = "accountId"
        static let aps = "aps"
        static let badge = "badge"
        static let userSettings = "userSettings"
    }
    
    struct Notification {
        static let newMessage = "NewMessage"
    }
    struct Api {
//        static let baseUrl: String = "http://74.208.252.135/v1"
        static let baseUrl: String = "http://93.188.167.68/projects/event_app/public/api/v1"
        enum Method: String {
            case login = "/accounts/login"
            case signIn = "/access-tokens"
            case signInFB = "/access-tokens/facebook"
            case accounts = "/account"
            case checkInstagram = "/accounts/check-instagram-username"
            case signUpFB = "/accounts/facebook"
            case profile = "/accounts/self"
            case deleteAccount = "/accounts/self/delete-account"
            case profilePosts = "/accounts/self/posts"
            case profileMoveTop = "/accounts/self/top"
            case statistics = "/accounts/self/stats"
            case ethnicities = "/ethnicities"
            case categories = "/categories"
            case favorites = "/favorites/self"
            case media = "/medias"
            case posts = "/posts"
            case searches = "/searches"
            case locations = "/accounts/self/locations"
            case currentLocation = "/accounts/self/point"
            case subscription = "/accounts/self/pro"
            case balance = "/balances/self"
            case pnToken = "/accounts/self/device-token"
            case video = "/videos"
            case chat = "/conversations"
            case bans = "/bans"
            case select = "/select"
            case settings = "/accounts/self/settings"
            case passwords = "/passwords"
            case updatePassword = "/passwords/update"
            case reportAccount = "/reports/"
        }
        
        static func urlWithMethod(_ method: Method) -> String {
            return Api.baseUrl + method.rawValue
        }
        
        static func getPostUrl(forId id: String) -> String {
            return Api.baseUrl + Method.accounts.rawValue + "/\(id)" + Method.posts.rawValue
        }
    }
}
