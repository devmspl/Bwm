//
//  Settings.swift
//
//  Created by obozhdi on 17/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class Settings: NSObject, Mappable, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let pushNotifications = "pushNotifications"
        static let emailNotifications = "emailNotifications"
        static let search = "search"
        static let tracking = "tracking"
    }
    
    // MARK: Properties
    public var pushNotifications: Int = 0
    public var emailNotifications: Int = 0
    public var search: Int = 0
    public var tracking: Int = 0
    
    
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
        pushNotifications <- map[SerializationKeys.pushNotifications]
        emailNotifications <- map[SerializationKeys.emailNotifications]
        search <- map[SerializationKeys.search]
        tracking <- map[SerializationKeys.tracking]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.pushNotifications] = pushNotifications
        dictionary[SerializationKeys.emailNotifications] = emailNotifications
        dictionary[SerializationKeys.search] = search
        dictionary[SerializationKeys.tracking] = tracking
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.pushNotifications = aDecoder.decodeInteger(forKey: SerializationKeys.pushNotifications)
        self.emailNotifications = aDecoder.decodeInteger(forKey: SerializationKeys.emailNotifications)
        self.search = aDecoder.decodeInteger(forKey: SerializationKeys.search)
        self.tracking = aDecoder.decodeInteger(forKey: SerializationKeys.tracking)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(pushNotifications , forKey: SerializationKeys.pushNotifications)
        aCoder.encode(emailNotifications , forKey: SerializationKeys.emailNotifications)
        aCoder.encode(search , forKey: SerializationKeys.search)
        aCoder.encode(tracking, forKey: SerializationKeys.tracking)
    }
    
}
