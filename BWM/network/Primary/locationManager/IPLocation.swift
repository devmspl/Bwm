//
//  Location.swift
//
//  Created by obozhdi on 16/07/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class IPLocation: Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let city = "city"
    static let lat = "lat"
    static let lon = "lon"
    static let regionName = "regionName"
    static let status = "status"
    static let zip = "zip"
    static let countryCode = "countryCode"
    static let region = "region"
    static let country = "country"
  }

  // MARK: Properties
  public var city: String?
  public var lat: Float?
  public var regionName: String?
  public var status: String?
  public var zip: String?
  public var countryCode: String?
  public var lon: Float?
  public var region: String?
  public var country: String?

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
    city <- map[SerializationKeys.city]
    lat <- map[SerializationKeys.lat]
    regionName <- map[SerializationKeys.regionName]
    status <- map[SerializationKeys.status]
    zip <- map[SerializationKeys.zip]
    countryCode <- map[SerializationKeys.countryCode]
    lon <- map[SerializationKeys.lon]
    region <- map[SerializationKeys.region]
    country <- map[SerializationKeys.country]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = city { dictionary[SerializationKeys.city] = value }
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    if let value = regionName { dictionary[SerializationKeys.regionName] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = zip { dictionary[SerializationKeys.zip] = value }
    if let value = countryCode { dictionary[SerializationKeys.countryCode] = value }
    if let value = lon { dictionary[SerializationKeys.lon] = value }
    if let value = region { dictionary[SerializationKeys.region] = value }
    if let value = country { dictionary[SerializationKeys.country] = value }
    return dictionary
  }

}
