//
//  Point.swift
//
//  Created by obozhdi on 16/07/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class Point: Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let longitude = "longitude"
    static let latitude = "latitude"
  }

  // MARK: Properties
  public var longitude: String?
  public var latitude: String?

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
    longitude <- map[SerializationKeys.longitude]
    latitude <- map[SerializationKeys.latitude]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    return dictionary
  }

}
