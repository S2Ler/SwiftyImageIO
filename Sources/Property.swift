//
//  Options.swift
//  SwiftyImageIO
//
//  Created by Alexander Belyavskiy on 6/25/16.
//  Copyright © 2016 Alexander Belyavskiy. All rights reserved.
//

import Foundation
import ImageIO

public protocol Property {
  var imageIOOption: (key: String, value: AnyObject) { get }
}

public protocol ImageProperty: Property {
  static var key: String { get }
  
  init?(imageIOKey: String, value: AnyObject)
}

public final class AnyImageProperties {
  private let rawImageProperties: CFDictionary
  public let propertiesKey: String
  
  fileprivate init<PropertyType: ImageProperty>(_ imageProperties: [PropertyType]) {
    guard let anyProperty = imageProperties.first else {
      preconditionFailure(".imageProperties should contain at least one property")      
    }
    
    let imagePropertyKey = type(of: anyProperty).key
    self.propertiesKey = imagePropertyKey
    self.rawImageProperties = imageProperties.rawProperties()
  }

  public func rawProperties() -> CFDictionary {
    return rawImageProperties
  }
}

public struct ImageProperties<PropertyType: ImageProperty> {
  fileprivate var imageProperties: [PropertyType]
  
  public init(_ imageProperties: [PropertyType]) {
    self.imageProperties = imageProperties
  }
  
  public init?(_ rawImageProperties: [String: AnyObject]) {
    guard let innerRawProperties = rawImageProperties[PropertyType.key] as? [String: AnyObject] else {
      return nil
    }
    
    var imageProperties: [PropertyType] = []
    for (key, value) in innerRawProperties {
      guard let imageProperty = PropertyType(imageIOKey: key, value: value) else {
        continue
      }
      
      imageProperties.append(imageProperty)
    }
    
    self.init(imageProperties)
  }

  public init?(_ anyImageProperties: AnyImageProperties) {
    guard PropertyType.key == anyImageProperties.propertiesKey else {
      return nil
    }

    var imageProperties: [PropertyType] = []
    let rawImageProperties = anyImageProperties.rawProperties() as! Dictionary<String, AnyObject>
    for (key, value) in rawImageProperties {
      guard let imageProperty = PropertyType(imageIOKey: key, value: value) else {
        continue
      }

      imageProperties.append(imageProperty)
    }

    self.init(imageProperties)
  }

  public var anyImageProperties: AnyImageProperties {
    return AnyImageProperties(imageProperties)
  }

  public mutating func append(_ property: PropertyType) {
    imageProperties.append(property)
  }
}

extension ImageProperties: Sequence {
  public func makeIterator() -> IndexingIterator<[PropertyType]> {
    return imageProperties.makeIterator()
  }
}

public extension Sequence where Iterator.Element: Property {
  public func rawProperties() -> CFDictionary {
    var dictionary: [String: AnyObject] = [:]
    for property in self {
      let (key, value) = property.imageIOOption
      dictionary[key] = value
    }
    
    return dictionary as CFDictionary
  }
}

public extension Sequence where Iterator.Element: ImageProperty {
  public func rawImageProperties() -> CFDictionary {
    let innerProperties = rawProperties()
    let outterProperties: [String: CFDictionary] = [Iterator.Element.key: innerProperties]
    return outterProperties as CFDictionary
  }
}

public func ~=(lhs: CFString, rhs: CFString) -> Bool {
  return (lhs as String) == (rhs as String)
}
