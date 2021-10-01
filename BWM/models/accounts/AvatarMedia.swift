//
//  AvatarMedia.swift
//
//  Created by obozhdi on 16/07/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class AvatarMedia: Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let thumbs = "thumbs"
    static let id = "id"
    static let type = "type"
    static let url = "url"
  }

  // MARK: Properties
  public var thumbs: Thumbs?
  public var id: Int?
  public var type: String?
  public var url: String?

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
    thumbs <- map[SerializationKeys.thumbs]
    id <- map[SerializationKeys.id]
    type <- map[SerializationKeys.type]
    url <- map[SerializationKeys.url]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = thumbs { dictionary[SerializationKeys.thumbs] = value.dictionaryRepresentation() }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = url { dictionary[SerializationKeys.url] = value }
    return dictionary
  }

}
