//
//  AuthObject.swift
//
//  Created by obozhdi on 17/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

public final class AuthObject: Mappable {
    
    private struct SerializationKeys {
        
        static let igSynced          = "isIgSynced"
        static let hireCountPro      = "hireCountPro"
        static let fullness          = "fullness"
        static let interviewCountPro = "interviewCountPro"
        static let ethnicity         = "ethnicity"
        static let category          = "category"
        static let isVerified        = "isVerified"
        static let isPro             = "isPro"
        static let position          = "position"
        static let birthDate         = "birthDate"
        static let balance           = "balance"
        static let hireCount         = "hireCount"
        static let id                = "id"
        static let settings          = "settings"
        static let fullName          = "fullName"
        static let isCustomer        = "isCustomer"
        static let viewCount         = "viewCount"
        static let verificationCode  = "verificationCode"
        static let viewCountPro      = "viewCountPro"
        static let avatarMedia       = "avatarMedia"
        static let interviewCount    = "interviewCount"
        static let email             = "email"
        static let postCount         = "postCount"
        static let createdAt         = "createdAt"
        static let accessToken       = "accessToken"
        static let gender            = "gender"
        static let locations         = "locations"
        static let instagramId       = "instagramId"
        static let followerCount     = "followerCount"
        static let username          = "username"
        static let about             = "about"
        static let updatedAt         = "updatedAt"
        static let profile           = "profile"
        static let profilePro        = "profilePro"
        static let message           = "message"
        static let messagePro        = "messagePro"
        static let search            = "search"
        static let searchPro         = "searchPro"
        static let firstName         = "firstName"
        static let lastName          = "lastName"
    }
    
    // MARK: Properties
    public var igSynced: Bool? = false
    public var hireCountPro: Int = 0
    public var fullness: Int = 0
    public var interviewCountPro: Int = 0
    public var ethnicity: Ethnicity?
    public var category: Category?
    public var isVerified: Bool? = false
    public var isPro: Bool? = false
    public var position: Int = 0
    public var birthDate: String = ""
    public var balance: Balance?
    public var hireCount: Int = 0
    public var id: Int = 0
    public var settings: Settings?
    public var firstName: String?
    public var lastName: String?
    public var isCustomer: Bool? = false
    public var viewCount: Int = 0
    public var verificationCode: String = ""
    public var viewCountPro: Int = 0
    public var avatarMedia: AvatarMedia?
    public var interviewCount: Int = 0
    public var email: String = ""
    public var postCount: Int = 0
    public var createdAt: Int = 0
    public var accessToken: String = ""
    public var gender: Int = -1
    public var locations: [Locations]?
    public var instagramId: String = ""
    public var followerCount: Int = 0
    public var username: String = ""
    public var about: String = ""
    public var updatedAt: Int = 0
    public var profile: Int = 0
    public var profilePro: Int = 0
    public var message: Int = 0
    public var messagePro: Int = 0
    public var search: Int = 0
    public var searchPro: Int = 0
    
    public var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
    
    public required init?(map: Map){
        
    }

    public func mapping(map: Map) {
        igSynced <- map[SerializationKeys.igSynced]
        hireCountPro <- map[SerializationKeys.hireCountPro]
        fullness <- map[SerializationKeys.fullness]
        interviewCountPro <- map[SerializationKeys.interviewCountPro]
        ethnicity <- map[SerializationKeys.ethnicity]
        category <- map[SerializationKeys.category]
        isVerified <- map[SerializationKeys.isVerified]
        isPro <- map[SerializationKeys.isPro]
        position <- map[SerializationKeys.position]
        birthDate <- map[SerializationKeys.birthDate]
        balance <- map[SerializationKeys.balance]
        hireCount <- map[SerializationKeys.hireCount]
        id <- map[SerializationKeys.id]
        settings <- map[SerializationKeys.settings]
        firstName <- map[SerializationKeys.firstName]
        lastName <- map[SerializationKeys.lastName]
        isCustomer <- map[SerializationKeys.isCustomer]
        viewCount <- map[SerializationKeys.viewCount]
        verificationCode <- map[SerializationKeys.verificationCode]
        viewCountPro <- map[SerializationKeys.viewCountPro]
        avatarMedia <- map[SerializationKeys.avatarMedia]
        interviewCount <- map[SerializationKeys.interviewCount]
        email <- map[SerializationKeys.email]
        postCount <- map[SerializationKeys.postCount]
        createdAt <- map[SerializationKeys.createdAt]
        accessToken <- map[SerializationKeys.accessToken]
        gender <- map[SerializationKeys.gender]
        locations <- map[SerializationKeys.locations]
        instagramId <- map[SerializationKeys.instagramId]
        followerCount <- map[SerializationKeys.followerCount]
        username <- map[SerializationKeys.username]
        about <- map[SerializationKeys.about]
        updatedAt <- map[SerializationKeys.updatedAt]
        profile <- map[SerializationKeys.profile]
        profilePro <- map[SerializationKeys.profilePro]
        message <- map[SerializationKeys.message]
        messagePro <- map[SerializationKeys.messagePro]
        search <- map[SerializationKeys.search]
        searchPro <- map[SerializationKeys.searchPro]
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            SerializationKeys.email: self.email,
            SerializationKeys.username: self.username,
            SerializationKeys.firstName: self.firstName ?? "",
            SerializationKeys.lastName: self.lastName ?? "",
            SerializationKeys.birthDate: self.birthDate,
            SerializationKeys.gender: self.gender,
        ]
        
        if let ethnicity = self.ethnicity {
            dict["ethnicityId"] = ethnicity.id
        }
        if let category = self.category {
            dict["categoryId"] = category.id
        }
        if let location = self.locations?.first,
            let lat = location.latitude,
            let lon = location.longitude,
            let address = location.address {
            dict["latitude"] = lat
            dict["longitude"] = lon
            dict["address"] = address
        }
        
        return dict
    }
    
    func shortDescription() -> String {
        var bigString = ""
        var isoDate = ""
        
        if (self.birthDate.count) > 1 {
            isoDate = (self.birthDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from:isoDate)!
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            
            let age: Int = 2018 - Int(components.year!)
            
            bigString += "\(age) years"
        }
        
        if (self.gender) == 0 {
            bigString += "/"
            bigString += "man"
        } else if (self.gender) == 1 {
            bigString += "/"
            bigString += "woman"
        }
        
        if self.ethnicity != nil {
            if (self.ethnicity?.name?.count)! > 1 {
                bigString += "/"
                bigString += "\((self.ethnicity?.name)!)"
            }
        }
        
        if self.category != nil {
            if (self.category?.name?.count)! > 1 {
                bigString += "/"
                bigString += "\((self.category?.name)!)"
            }
        }
        
        return bigString
    }
}
