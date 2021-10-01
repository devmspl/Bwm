//
//  AlienAccount.swift
//
//  Created by obozhdi on 16/07/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

public class AlienAccount: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let postCount = "postCount"
        static let fullness = "fullness"
        static let gender = "gender"
        static let ethnicity = "ethnicity"
        static let category = "category"
        static let locations = "locations"
        static let isVerified = "isVerified"
        static let position = "position"
        static let birthDate = "birthDate"
        static let followerCount = "followerCount"
        static let isPro = "isPro"
        static let id = "id"
        static let isCustomer = "isCustomer"
        static let about = "about"
        static let isIgSynced = "isIgSynced"
        static let avatarMedia = "avatarMedia"
        static let isBanned = "isBanned"
        static let fullName = "fullName"
        static let isFavorite = "isFavorite"
        static let firstName = "firstName"
        static let lastName = "lastName"
    }
    
    // MARK: Properties
    public var postCount: Int?
    public var fullness: Int?
    public var gender: Int?
    public var ethnicity: Ethnicity?
    public var category: Category?
    public var locations: [Locations]?
    public var isVerified: Bool? = false
    public var position: Int?
    public var birthDate: String?
    public var followerCount: Int?
    public var isPro: Bool? = false
    public var id: Int?
    public var isCustomer: Bool? = false
    public var about: String?
    public var isIgSynced: Bool? = false
    public var avatarMedia: AvatarMedia?
    public var isBanned: Bool? = false
    public var isFavorite: Bool = false
    public var hasContact: Bool = false
    public var firstName: String?
    public var lastName: String?
    
    public var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
    
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public required init?(map: Map){
        
    }
    
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public func mapping(map: Map) {
        postCount <- map[SerializationKeys.postCount]
        fullness <- map[SerializationKeys.fullness]
        gender <- map[SerializationKeys.gender]
        ethnicity <- map[SerializationKeys.ethnicity]
        category <- map[SerializationKeys.category]
        locations <- map[SerializationKeys.locations]
        isVerified <- map[SerializationKeys.isVerified]
        position <- map[SerializationKeys.position]
        birthDate <- map[SerializationKeys.birthDate]
        followerCount <- map[SerializationKeys.followerCount]
        isPro <- map[SerializationKeys.isPro]
        id <- map[SerializationKeys.id]
        isCustomer <- map[SerializationKeys.isCustomer]
        about <- map[SerializationKeys.about]
        isIgSynced <- map[SerializationKeys.isIgSynced]
        avatarMedia <- map[SerializationKeys.avatarMedia]
        isBanned <- map[SerializationKeys.isBanned]
        firstName <- map[SerializationKeys.firstName]
        lastName <- map[SerializationKeys.lastName]
        isFavorite <- map[SerializationKeys.isFavorite]
        hasContact <- map["hasContact"]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = postCount { dictionary[SerializationKeys.postCount] = value }
        if let value = fullness { dictionary[SerializationKeys.fullness] = value }
        if let value = gender { dictionary[SerializationKeys.gender] = value }
        if let value = ethnicity { dictionary[SerializationKeys.ethnicity] = value.dictionaryRepresentation() }
        if let value = category { dictionary[SerializationKeys.category] = value.dictionaryRepresentation() }
        if let value = locations { dictionary[SerializationKeys.locations] = value.map { $0.dictionaryRepresentation() } }
        dictionary[SerializationKeys.isVerified] = isVerified
        if let value = position { dictionary[SerializationKeys.position] = value }
        if let value = birthDate { dictionary[SerializationKeys.birthDate] = value }
        if let value = followerCount { dictionary[SerializationKeys.followerCount] = value }
        dictionary[SerializationKeys.isPro] = isPro
        if let value = id { dictionary[SerializationKeys.id] = value }
        dictionary[SerializationKeys.isCustomer] = isCustomer
        if let value = about { dictionary[SerializationKeys.about] = value }
        dictionary[SerializationKeys.isIgSynced] = isIgSynced
        if let value = avatarMedia { dictionary[SerializationKeys.avatarMedia] = value.dictionaryRepresentation() }
        dictionary[SerializationKeys.isBanned] = isBanned
        return dictionary
    }
    
    func shortDescription() -> String {
        var bigString = ""
        var isoDate = ""
        
        if (self.birthDate?.count ?? 0) > 1 {
            isoDate = (self.birthDate ?? "")
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
