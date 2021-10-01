//
//  Locations.swift
//
//  Created by obozhdi on 16/07/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class Locations: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let latitude = "latitude"
        static let id = "id"
        static let longitude = "longitude"
        static let address = "address"
        static let isSelected = "is_selected"
    }
    
    // MARK: Properties
    public var latitude: String?
    public var id: Int?
    public var longitude: String?
    public var address: String?
    public var isSelected: Bool = false
    
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
        latitude <- map[SerializationKeys.latitude]
        id <- map[SerializationKeys.id]
        longitude <- map[SerializationKeys.longitude]
        address <- map[SerializationKeys.address]
        isSelected <- map[SerializationKeys.isSelected]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = latitude { dictionary[SerializationKeys.latitude] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = longitude { dictionary[SerializationKeys.longitude] = value }
        if let value = address { dictionary[SerializationKeys.address] = value }
        return dictionary
    }
    
}
