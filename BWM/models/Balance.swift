//
//  Balance.swift
//
//  Created by obozhdi on 17/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class Balance: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let tokens = "tokens"
  }

  // MARK: Properties
  public var tokens: Int?

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
    tokens <- map[SerializationKeys.tokens]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = tokens { dictionary[SerializationKeys.tokens] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.tokens = aDecoder.decodeObject(forKey: SerializationKeys.tokens) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(tokens, forKey: SerializationKeys.tokens)
  }

}
