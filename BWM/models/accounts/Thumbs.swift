//
//  Thumbs.swift
//
//  Created by obozhdi on 16/07/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class Thumbs: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let x200 = "x200"
        static let x100 = "x100"
        static let x300 = "x300"
    }
    
    // MARK: Properties
    public var x200: String?
    public var x100: String?
    private var _x300: String?
    
    public var x300: String? {
        get {
            return _x300 ?? x200
        }
        set {
            _x300 = newValue
        }
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
        x200 <- map[SerializationKeys.x200]
        x100 <- map[SerializationKeys.x100]
        _x300 <- map[SerializationKeys.x300]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = x200 { dictionary[SerializationKeys.x200] = value }
        if let value = x100 { dictionary[SerializationKeys.x100] = value }
        if let value = _x300 { dictionary[SerializationKeys.x300] = value }
        return dictionary
    }
    
}
