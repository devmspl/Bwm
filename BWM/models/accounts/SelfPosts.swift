//
//  SelfPosts.swift
//
//  Created by obozhdi on 12/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class SelfPost: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let picturePreviewUrl = "picturePreviewUrl"
    static let id = "id"
    static let pictureUrl = "pictureUrl"
    static let createdAt = "createdAt"
    static let likeCount = "likeCount"
    static let updatedAt = "updatedAt"
    static let body = "body"
    static let commentCount = "commentCount"
    static let instagramId = "instagramId"
  }

  // MARK: Properties
  public var picturePreviewUrl: String?
  public var id: Int?
  public var pictureUrl: String?
  public var createdAt: Int?
  public var likeCount: Int?
  public var updatedAt: Int?
  public var body: String?
  public var commentCount: Int?
  public var instagramId: String?

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public required init?(map: Map) {

  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    picturePreviewUrl <- map[SerializationKeys.picturePreviewUrl]
    id <- map[SerializationKeys.id]
    pictureUrl <- map[SerializationKeys.pictureUrl]
    createdAt <- map[SerializationKeys.createdAt]
    likeCount <- map[SerializationKeys.likeCount]
    updatedAt <- map[SerializationKeys.updatedAt]
    body <- map[SerializationKeys.body]
    commentCount <- map[SerializationKeys.commentCount]
    instagramId <- map[SerializationKeys.instagramId]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = picturePreviewUrl { dictionary[SerializationKeys.picturePreviewUrl] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = pictureUrl { dictionary[SerializationKeys.pictureUrl] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    if let value = likeCount { dictionary[SerializationKeys.likeCount] = value }
    if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
    if let value = body { dictionary[SerializationKeys.body] = value }
    if let value = commentCount { dictionary[SerializationKeys.commentCount] = value }
    if let value = instagramId { dictionary[SerializationKeys.instagramId] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.picturePreviewUrl = aDecoder.decodeObject(forKey: SerializationKeys.picturePreviewUrl) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.pictureUrl = aDecoder.decodeObject(forKey: SerializationKeys.pictureUrl) as? String
    self.createdAt = aDecoder.decodeObject(forKey: SerializationKeys.createdAt) as? Int
    self.likeCount = aDecoder.decodeObject(forKey: SerializationKeys.likeCount) as? Int
    self.updatedAt = aDecoder.decodeObject(forKey: SerializationKeys.updatedAt) as? Int
    self.body = aDecoder.decodeObject(forKey: SerializationKeys.body) as? String
    self.commentCount = aDecoder.decodeObject(forKey: SerializationKeys.commentCount) as? Int
    self.instagramId = aDecoder.decodeObject(forKey: SerializationKeys.instagramId) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(picturePreviewUrl, forKey: SerializationKeys.picturePreviewUrl)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(pictureUrl, forKey: SerializationKeys.pictureUrl)
    aCoder.encode(createdAt, forKey: SerializationKeys.createdAt)
    aCoder.encode(likeCount, forKey: SerializationKeys.likeCount)
    aCoder.encode(updatedAt, forKey: SerializationKeys.updatedAt)
    aCoder.encode(body, forKey: SerializationKeys.body)
    aCoder.encode(commentCount, forKey: SerializationKeys.commentCount)
    aCoder.encode(instagramId, forKey: SerializationKeys.instagramId)
  }

}
