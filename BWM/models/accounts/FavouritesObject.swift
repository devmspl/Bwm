//
//  FavouritesObject.swift
//
//  Created by obozhdi on 20/07/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class FavouritesObject: Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let favoriteAccount = "favoriteAccount"
    static let createdAt = "createdAt"
  }

  // MARK: Properties
  public var favoriteAccount: FavoriteAccount?
  public var createdAt: Int?

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
    favoriteAccount <- map[SerializationKeys.favoriteAccount]
    createdAt <- map[SerializationKeys.createdAt]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = favoriteAccount { dictionary[SerializationKeys.favoriteAccount] = value.dictionaryRepresentation() }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    return dictionary
  }

}
