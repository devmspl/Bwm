//
//  StatsObject.swift
//
//  Created by obozhdi on 04/08/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class StatsObject: Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let profilePro = "profilePro"
    static let search = "search"
    static let date = "date"
    static let message = "message"
    static let searchPro = "searchPro"
    static let messagePro = "messagePro"
    static let profile = "profile"
  }

  // MARK: Properties
  public var profilePro: Int?
  public var search: Int?
  public var date: String?
  public var message: Int?
  public var searchPro: Int?
  public var messagePro: Int?
  public var profile: Int?

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
    profilePro <- map[SerializationKeys.profilePro]
    search <- map[SerializationKeys.search]
    date <- map[SerializationKeys.date]
    message <- map[SerializationKeys.message]
    searchPro <- map[SerializationKeys.searchPro]
    messagePro <- map[SerializationKeys.messagePro]
    profile <- map[SerializationKeys.profile]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = profilePro { dictionary[SerializationKeys.profilePro] = value }
    if let value = search { dictionary[SerializationKeys.search] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = message { dictionary[SerializationKeys.message] = value }
    if let value = searchPro { dictionary[SerializationKeys.searchPro] = value }
    if let value = messagePro { dictionary[SerializationKeys.messagePro] = value }
    if let value = profile { dictionary[SerializationKeys.profile] = value }
    return dictionary
  }

}
